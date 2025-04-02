return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "swift",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        sourcekit = {},
      },
    },
  },
  {
    {
      "folke/snacks.nvim",
      opts = {
        picker = {
          hidden = true, -- for hidden files
          ignored = true, -- for .gitignore files
        },
      },
    },
  },
}
