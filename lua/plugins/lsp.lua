return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      sourcekit = {},
      clangd = {
        -- Use the clangd on PATH; Mason's binary does not support this ARM64 host.
        mason = false,
      },
    },
  },
}
