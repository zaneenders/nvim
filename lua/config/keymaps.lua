-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Load scribe functionality
local scribe = require("config.scribe")

-- Unbind <leader><leader> after LazyVim loads (redundant with <leader>ff)
-- Use defer to ensure we run after all lazy-loaded plugins
vim.defer_fn(function()
  -- Check if the mapping exists and what it maps to
  local mapping = vim.fn.maparg("<leader><leader>", "n")
  if mapping ~= "" then
    vim.keymap.del("n", "<leader><leader>")
  end
  -- Ensure no mapping exists, then set up which-key properly
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add({
      { "<leader><leader>", group = "scribe" },
    })
  end
end, 100)

-- Scribe keybindings using <leader><leader> prefix
vim.keymap.set("n", "<leader><leader>m", function()
  scribe.run("markdown", "markdown")
end, { desc = "Scribe Markdown" })

vim.keymap.set("n", "<leader><leader>l", function()
  scribe.run("log", "log")
end, { desc = "Scribe Log" })
