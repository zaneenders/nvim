-- Run from the config directory: nvim --headless -u NONE -l tests/clipboard.lua
local writes = {}
package.loaded["vim.ui.clipboard.osc52"] = {
  copy = function(register)
    return function(lines, regtype)
      writes[#writes + 1] = { register = register, lines = vim.deepcopy(lines), regtype = regtype }
    end
  end,
  paste = function()
    error("OSC 52 clipboard reads must not be used")
  end,
}

local function load_options(env)
  vim.env.SSH_TTY = env.SSH_TTY
  vim.env.SSH_CONNECTION = env.SSH_CONNECTION
  vim.env.WAYLAND_DISPLAY = env.WAYLAND_DISPLAY
  vim.g.clipboard = nil
  vim.g.loaded_clipboard_provider = nil
  writes = {}
  dofile("lua/config/options.lua")
  assert(vim.o.clipboard == "unnamedplus")
end

local function equal(expected, actual)
  assert(vim.deep_equal(expected, actual), "Expected " .. vim.inspect(expected) .. ", got " .. vim.inspect(actual))
end

for _, env in ipairs({ {}, { WAYLAND_DISPLAY = "wayland-0" } }) do
  load_options(env)
  assert(vim.g.clipboard == nil, "Local sessions must retain native clipboard detection")
  equal({}, writes)
end

for _, env in ipairs({
  { SSH_TTY = "/dev/pts/1" },
  { SSH_CONNECTION = "192.0.2.1 12345 192.0.2.2 22" },
  { SSH_TTY = "/dev/pts/1", SSH_CONNECTION = "192.0.2.1 12345 192.0.2.2 22", WAYLAND_DISPLAY = "wayland-0" },
}) do
  load_options(env)
  vim.cmd("runtime autoload/provider/clipboard.vim")
  equal("OSC 52", vim.fn["provider#clipboard#Executable"]())

  for _, register in ipairs({ "+", "*" }) do
    equal({ { "" }, "v" }, vim.fn["provider#clipboard#Call"]("get", { register }))
    for _, sample in ipairs({
      { lines = { "characters" }, regtype = "v" },
      { lines = { "first", "second" }, regtype = "V" },
      { lines = { "ab", "cd" }, regtype = "\0222", clipboard_type = "b" },
    }) do
      vim.fn.setreg(register, sample.lines, sample.regtype)
      equal(sample.lines, vim.fn.getreg(register, 1, true))
      equal(sample.regtype, vim.fn.getregtype(register))
      local copied_lines = vim.deepcopy(sample.lines)
      -- Non-characterwise clipboard writes include a final newline; block width is inferred on read.
      if sample.regtype ~= "v" then
        copied_lines[#copied_lines + 1] = ""
      end
      equal(
        { register = register, lines = copied_lines, regtype = sample.clipboard_type or sample.regtype },
        writes[#writes]
      )
    end
  end

  vim.fn.setreg("+", "clipboard", "v")
  vim.fn.setreg("*", "selection", "v")
  equal("clipboard", vim.fn.getreg("+"))
  equal("selection", vim.fn.getreg("*"))

  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "cached line", "tail" })
  vim.cmd("normal! ggyyGp")
  equal({ "cached line", "tail", "cached line" }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

print("Clipboard tests passed (native detection unchanged; SSH caches both registers and register types)")
