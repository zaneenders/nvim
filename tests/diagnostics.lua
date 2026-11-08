-- Run from the config directory: nvim --headless -u NONE -l tests/diagnostics.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
require("config.diagnostics").setup()
vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
vim.wo.number = true
vim.wo.signcolumn = "yes"

local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
  "func deflate(input: borrowing Span<UInt8>) -> OutputSpan {",
  "  OutputSpan()",
  "}",
})
local namespace = vim.api.nvim_create_namespace("wrap_test")
local other_namespace = vim.api.nvim_create_namespace("wrap_test_other")

local function flush()
  local done = false
  vim.schedule(function()
    done = true
  end)
  assert(vim.wait(1000, function()
    return done
  end))
end

local function marks(ns)
  local display_ns = vim.diagnostic.get_namespace(ns).user_data.virt_lines_ns
  return display_ns and vim.api.nvim_buf_get_extmarks(buf, display_ns, 0, -1, { details = true }) or {}
end

local function check(ns, message)
  local text, count = {}, 0
  for _, mark in ipairs(marks(ns)) do
    for _, chunks in ipairs(mark[4].virt_lines or {}) do
      local line = ""
      for _, chunk in ipairs(chunks) do
        line = line .. chunk[1]
      end
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        local width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff
        assert(vim.fn.strdisplaywidth(line) <= width, "diagnostic was clipped")
      end
      text[#text + 1] = chunks[#chunks][1]
      count = count + 1
    end
  end
  assert(count > 1, "long diagnostic did not wrap")
  assert(table.concat(text):gsub("%s", "") == message:gsub("%s", ""), "diagnostic text was lost")
end

local messages = {
  string.rep("Reference to generic type OutputSpan requires arguments in angle brackets. ", 4),
  "Unexpected type: " .. string.rep("VeryLongGenericParameter", 15),
  string.rep("Unicode: 中文 café é.\nAnother diagnostic line.\n", 4),
}
for _, message in ipairs(messages) do
  vim.diagnostic.set(namespace, buf, { { lnum = 0, col = 45, end_col = 55, severity = 1, message = message } })
  for _, width in ipairs({ 140, 80, 40 }) do
    vim.o.columns = width
    vim.api.nvim_exec_autocmds("VimResized", {})
    flush()
    check(namespace, message)
  end
  local stored = vim.diagnostic.get(buf, { namespace = namespace })[1]
  assert(stored.col == 45 and stored.end_col == 55 and stored.message == message, "original diagnostic was modified")
end

local message = messages[1]
vim.diagnostic.set(namespace, buf, { { lnum = 0, col = 45, severity = 1, message = message } })
vim.diagnostic.set(other_namespace, buf, { { lnum = 0, col = 20, severity = 2, message = message } })
vim.o.columns = 140
vim.cmd("vsplit")
vim.api.nvim_win_set_width(0, 40)
vim.api.nvim_exec_autocmds("WinResized", {})
flush()
check(namespace, message)
check(other_namespace, message)

vim.diagnostic.reset(namespace, buf)
assert(#marks(namespace) == 0, "reset left stale diagnostics")
check(other_namespace, message)
vim.diagnostic.enable(false, { bufnr = buf })
vim.api.nvim_exec_autocmds("VimResized", {})
flush()
assert(#marks(other_namespace) == 0, "disabled diagnostics reappeared")
vim.diagnostic.enable(true, { bufnr = buf })
check(other_namespace, message)

vim.api.nvim_win_set_cursor(0, { 3, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", {})
assert(#marks(other_namespace) == 0, "diagnostics did not follow the cursor")
vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", {})
check(other_namespace, message)
vim.diagnostic.reset(other_namespace, buf)
assert(#marks(other_namespace) == 0, "last reset left stale diagnostics")

print("Diagnostics passed: wrapping, resizing, long words, Unicode, splits, cursor movement, reset, and disable/enable")
