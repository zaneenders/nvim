return {
  "Julian/lean.nvim",
  opts = function()
    return { mappings = true }
  end,
  config = function(_, opts)
    -- Current lean.nvim reads options from vim.g.lean_config.
    vim.g.lean_config = opts
  end,
}
