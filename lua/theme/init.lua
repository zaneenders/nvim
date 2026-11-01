-- Apply the local palette and the copied highlight definitions.
local M = {}

function M.load()
  -- Reload edited palette/settings/groups when :colorscheme local-night is run.
  for name in pairs(package.loaded) do
    if name == "theme.palette" or name == "theme.config" or name:match("^theme%.groups%.") then
      package.loaded[name] = nil
    end
  end
  local opts = require("theme.config")
  local colors = require("theme.colors").setup(opts)
  local groups = {}
  for _, name in ipairs({ "base", "kinds", "semantic_tokens", "treesitter", "snacks", "blink", "mini_icons", "lazy" }) do
    for group, value in pairs(require("theme.groups." .. name).get(colors, opts)) do
      groups[group] = value
    end
  end
  groups = vim.tbl_extend("force", groups, opts.highlights)
  require("theme.util").resolve(groups)

  vim.cmd("highlight clear")
  vim.o.background = "dark"
  vim.o.termguicolors = true
  vim.g.colors_name = "local-night"
  for group, value in pairs(groups) do
    vim.api.nvim_set_hl(0, group, type(value) == "string" and { link = value } or value)
  end

  if opts.terminal_colors then
    local terminal = colors.terminal
    local palette = {
      terminal.black,
      terminal.red,
      terminal.green,
      terminal.yellow,
      terminal.blue,
      terminal.magenta,
      terminal.cyan,
      terminal.white,
      terminal.black_bright,
      terminal.red_bright,
      terminal.green_bright,
      terminal.yellow_bright,
      terminal.blue_bright,
      terminal.magenta_bright,
      terminal.cyan_bright,
      terminal.white_bright,
    }
    for index, color in ipairs(palette) do
      vim.g["terminal_color_" .. (index - 1)] = color
    end
  end
end

return M
