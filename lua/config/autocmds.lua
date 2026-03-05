-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Store the initial working directory when nvim starts
vim.g.nvim_initial_cwd = vim.fn.getcwd()

-- Prevent directory changes when opening Package.swift or other project files
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.swift",
  callback = function()
    -- Don't change directory when opening Package.swift files
    local filename = vim.fn.expand("%:t")
    if filename == "Package.swift" then
      vim.cmd("lcd " .. vim.g.nvim_initial_cwd)
    end
  end,
})
