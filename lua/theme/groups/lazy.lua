-- Derived from folke/tokyonight.nvim at cdc07ac78467a233fd62c493de29a17e0cf2b2b6.
-- Local modifications: Night-only theme, local modules, and selected plugin highlights.
-- Apache-2.0; see licenses/tokyonight-LICENSE.

local M = {}

M.url = "https://github.com/folke/lazy.nvim"

function M.get(c, opts)
  -- stylua: ignore
  return {
    LazyProgressDone = { bold = true, fg = c.magenta2 },
    LazyProgressTodo = { bold = true, fg = c.fg_gutter },
  }
end

return M
