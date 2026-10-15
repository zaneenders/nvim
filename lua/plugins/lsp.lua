return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      cssls = {},
      html = {},
      sourcekit = {
        -- SourceKit comes from the Swift toolchain on macOS or Linux.
        mason = false,
        enabled = vim.fn.executable("sourcekit-lsp") == 1,
      },
      clangd = {
        -- Prefer an existing toolchain; let Mason install clangd when needed.
        mason = vim.fn.executable("clangd") == 0,
      },
    },
  },
}
