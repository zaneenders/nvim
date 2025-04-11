return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "luacheck",
        "shellcheck",
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "swift",
        "html",
        "css",
        "javascript",
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
