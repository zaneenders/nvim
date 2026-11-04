return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
    local servers = {
      clangd = {},
    }

    local binaries = {
      clangd = "clangd",
    }
    local missing = {}
    for name, opts in pairs(servers) do
      vim.lsp.config(name, opts)
      if vim.fn.executable(binaries[name]) == 1 then
        vim.lsp.enable(name)
      else
        missing[#missing + 1] = binaries[name]
      end
    end
    if #missing > 0 then
      table.sort(missing)
      vim.notify(
        "Missing language servers on PATH: " .. table.concat(missing, ", ") .. ". See README setup.",
        vim.log.levels.WARN
      )
    end

    -- SourceKit is optional and comes with the Swift toolchain.
    if vim.fn.executable("sourcekit-lsp") == 1 then
      vim.lsp.config("sourcekit", { filetypes = { "swift" } })
      vim.lsp.enable("sourcekit")
    end
  end,
}
