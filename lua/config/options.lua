-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.guifont = "HackNerdFontMono-Regular:h12"
vim.opt.scrolloff = 8
vim.g.nofsync = true

-- Prevent auto-changing directories
vim.opt.autochdir = false

-- Disable LazyVim auto root detection - always use current working directory
vim.g.root_spec = { "cwd" }
