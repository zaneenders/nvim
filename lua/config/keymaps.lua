-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Unbind <leader><leader> (redundant with <leader>ff)
vim.keymap.del("n", "<leader><leader>")

-- Scribe keybindings using <leader><leader> prefix
vim.keymap.set("n", "<leader><leader>m", function()
  vim.fn.system("scribe markdown")
  vim.notify("Scribe: markdown", vim.log.levels.INFO)
end, { desc = "Scribe Markdown" })

vim.keymap.set("n", "<leader><leader>l", function()
  vim.fn.system("scribe log")
  vim.notify("Scribe: log", vim.log.levels.INFO)
end, { desc = "Scribe Log" })
