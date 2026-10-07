-- Run from the config directory: nvim --headless -u NONE -i NONE -l tests/config.lua
local ssh, wayland = vim.env.SSH_CONNECTION, vim.env.WAYLAND_DISPLAY
local executable = vim.fn.executable
for _, case in ipairs({
  { wayland = "wayland-1", copy = 1, paste = 1, osc52 = false },
  { wayland = "wayland-1", copy = 1, paste = 1, ssh = "test", osc52 = true },
  { copy = 1, paste = 1, osc52 = true },
  { wayland = "wayland-1", copy = 0, paste = 1, osc52 = true },
  { wayland = "wayland-1", copy = 1, paste = 0, osc52 = true },
}) do
  vim.env.SSH_CONNECTION, vim.env.WAYLAND_DISPLAY = case.ssh, case.wayland
  vim.g.clipboard = nil
  vim.fn.executable = function(command)
    assert(command == "wl-copy" or command == "wl-paste")
    return command == "wl-copy" and case.copy or case.paste
  end
  dofile("lua/config/options.lua")
  if case.osc52 then
    assert(vim.g.clipboard.name == "OSC 52")
    assert(type(vim.g.clipboard.copy["+"]) == "function")
    assert(type(vim.g.clipboard.paste["+"]) == "function")
  else
    assert(vim.g.clipboard == nil, "Let Neovim detect the local Wayland clipboard")
  end
end
vim.env.SSH_CONNECTION, vim.env.WAYLAND_DISPLAY = ssh, wayland
vim.fn.executable = executable
vim.g.clipboard = nil
print("PASS: Local Wayland clipboard and OSC 52 fallback")

local config_dir = vim.fn.getcwd()
local temp_dir = vim.fn.tempname() .. " project [test]"
vim.fn.mkdir(temp_dir .. "/other", "p")
vim.cmd("cd " .. vim.fn.fnameescape(temp_dir))
dofile(config_dir .. "/lua/config/autocmds.lua")
vim.cmd("cd " .. vim.fn.fnameescape(temp_dir .. "/other"))
local buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_buf_set_name(buf, temp_dir .. "/Package.swift")
vim.api.nvim_set_current_buf(buf)
assert(vim.fn.getcwd() == temp_dir, "Package.swift must restore paths with spaces and special characters")
assert(vim.fn.getcwd(-1, -1) == temp_dir .. "/other", "Keep directory restoration window-local")
vim.api.nvim_buf_delete(buf, { force = true })
vim.cmd("cd " .. vim.fn.fnameescape(config_dir))
vim.fn.delete(temp_dir, "rf")
print("PASS: Package.swift working directory escaping")

local mason_opts = { ensure_installed = { "existing-tool" } }
dofile("lua/plugins/mason.lua").opts(nil, mason_opts)
assert(vim.tbl_contains(mason_opts.ensure_installed, "existing-tool"))
assert(vim.tbl_contains(mason_opts.ensure_installed, "stylua"))
assert(
  not vim.tbl_contains(mason_opts.ensure_installed, "luacheck"),
  "Do not auto-install the unused Lua 5.5-incompatible linter"
)
print("PASS: Mason tool list")
