-- Derived from folke/tokyonight.nvim at cdc07ac78467a233fd62c493de29a17e0cf2b2b6.
-- Local modifications: Night-only theme, local modules, and selected plugin highlights.
-- Apache-2.0; see licenses/tokyonight-LICENSE.

local M = {}

M.url = "https://github.com/Saghen/blink.cmp"

function M.get(c, opts)
  -- stylua: ignore
  local ret = {
    BlinkCmpDoc                 = { fg = c.fg, bg               = c.bg_float },
    BlinkCmpDocBorder           = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpGhostText           = { fg = c.terminal_black },
    BlinkCmpKindCodeium         = { fg = c.teal, bg             = c.none },
    BlinkCmpKindCopilot         = { fg = c.teal, bg             = c.none },
    BlinkCmpKindDefault         = { fg = c.fg_dark, bg          = c.none },
    BlinkCmpKindSupermaven      = { fg = c.teal, bg             = c.none },
    BlinkCmpKindTabNine         = { fg = c.teal, bg             = c.none },
    BlinkCmpLabel               = { fg = c.fg, bg               = c.none },
    BlinkCmpLabelDeprecated     = { fg = c.fg_gutter, bg        = c.none, strikethrough = true },
    BlinkCmpLabelMatch          = { fg = c.blue1, bg            = c.none },
    BlinkCmpMenu                = { fg = c.fg, bg               = c.bg_float },
    BlinkCmpMenuBorder          = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpSignatureHelp       = { fg = c.fg, bg               = c.bg_float },
    BlinkCmpSignatureHelpBorder = { fg = c.border_highlight, bg = c.bg_float },
  }

  require("theme.groups.kinds").kinds(ret, "BlinkCmpKind%s")
  return ret
end

return M
