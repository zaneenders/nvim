return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    -- Language servers are installed through lsp.lua and the TypeScript extra.
    vim.list_extend(opts.ensure_installed, {
      "stylua",
      "luacheck",
    })
    if vim.fn.executable("shellcheck") == 0 then
      table.insert(opts.ensure_installed, "shellcheck")
    end
  end,
}
