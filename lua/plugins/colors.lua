return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = function(_, opts)
      opts.style = "night"
      -- Set the base palette before Tokyo Night derives UI, diff, and diagnostic colors.
      require("tokyonight.colors").styles.night = function()
        return vim.deepcopy(require("theme.palette"))
      end
      opts.on_highlights = function(highlights, colors)
        highlights.SnacksPickerPickWinCurrent = { fg = colors.bg, bg = colors.magenta2, bold = true }
      end
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
}
