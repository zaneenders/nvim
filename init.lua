if vim.fn.has("nvim-0.12") == 0 then
  error("This config requires Neovim 0.12 or newer")
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
vim.cmd.colorscheme("local-night")
require("config.autocmds")
require("config.lazy")
require("config.keymaps")
