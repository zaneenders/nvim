-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Override terminal keymaps to use global cwd instead of auto-detected root
vim.keymap.set({ "n", "t" }, "<c-/>", function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd(-1, -1) })
end, { desc = "Terminal (Global cwd)" })
vim.keymap.set({ "n", "t" }, "<c-_>", function()
  Snacks.terminal(nil, { cwd = vim.fn.getcwd(-1, -1) })
end, { desc = "which_key_ignore" })
