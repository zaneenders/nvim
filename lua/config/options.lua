-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
-- Let Neovim detect the local clipboard (macOS, Wayland, or X11).
-- Over SSH, copy via OSC 52 but paste from a cache: many terminals block clipboard reads.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local cached = {
    ["+"] = { { "" }, "v" },
    ["*"] = { { "" }, "v" },
  }
  local function copy(register)
    local copy_to_terminal = require("vim.ui.clipboard.osc52").copy(register)
    return function(lines, regtype)
      cached[register] = { vim.deepcopy(lines), regtype }
      copy_to_terminal(lines, regtype)
    end
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = copy("+"),
      ["*"] = copy("*"),
    },
    paste = {
      ["+"] = function()
        return vim.deepcopy(cached["+"])
      end,
      ["*"] = function()
        return vim.deepcopy(cached["*"])
      end,
    },
  }
end
vim.opt.guifont = "HackNerdFontMono-Regular:h12"
vim.opt.scrolloff = 8
vim.g.nofsync = true

-- Prevent auto-changing directories
vim.opt.autochdir = false

-- Disable LazyVim auto root detection - always use current working directory
vim.g.root_spec = { "cwd" }
