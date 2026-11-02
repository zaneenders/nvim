vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.laststatus = 3
vim.opt.statusline = "%f %m%r%=%y  %l:%c  %p%%"
vim.opt.confirm = true
vim.opt.clipboard = "unnamedplus"
-- Let Neovim detect the local clipboard (macOS, Wayland, or X11).
-- Rex can connect remotely without SSH; native tools would use the server's clipboard.
-- Copy via OSC 52 in Rex/SSH, but cache pastes because clipboard reads may be blocked.
if vim.env.REX_BLOCK or vim.env.TERM_PROGRAM == "rex" or vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
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

-- Prevent auto-changing directories
vim.opt.autochdir = false
