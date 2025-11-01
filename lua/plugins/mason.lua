return {
  "mason-org/mason.nvim",
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
}
