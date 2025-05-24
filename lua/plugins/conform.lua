return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Keep other filetype mappings
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = {}, -- Or a different formatter if desired
      },
    },
  },
}
