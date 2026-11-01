-- Derived from folke/tokyonight.nvim at cdc07ac78467a233fd62c493de29a17e0cf2b2b6.
-- Local modifications: Night-only theme, local modules, and selected plugin highlights.
-- Apache-2.0; see licenses/tokyonight-LICENSE.

local M = {}

M.url = "https://github.com/echasnovski/mini.icons"

function M.get(c)
  -- stylua: ignore
  return {
    MiniIconsGrey   = { fg = c.fg },
    MiniIconsPurple = { fg = c.purple },
    MiniIconsBlue   = { fg = c.blue },
    MiniIconsAzure  = { fg = c.info },
    MiniIconsCyan   = { fg = c.teal },
    MiniIconsGreen  = { fg = c.green },
    MiniIconsYellow = { fg = c.yellow },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsRed    = { fg = c.red },
  }
end

return M
