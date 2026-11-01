return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    explorer = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true, ignored = false },
        grep = { hidden = true, ignored = false },
        explorer = { hidden = true, ignored = false },
      },
    },
    input = { enabled = true },
    terminal = { enabled = true },
  },
}
