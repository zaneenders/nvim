local group = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(event)
    if vim.g.disable_autoformat or vim.b[event.buf].disable_autoformat then
      return
    end
    if #vim.lsp.get_clients({ bufnr = event.buf, method = "textDocument/formatting" }) > 0 then
      vim.lsp.buf.format({ bufnr = event.buf, async = false, timeout_ms = 1000 })
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Metal shares C++ highlighting, but must not attach clangd or SourceKit.
vim.filetype.add({ extension = { metal = "metal" } })
vim.treesitter.language.register("cpp", "metal")
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "metal",
  callback = function(event)
    vim.bo[event.buf].syntax = "cpp"
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local function map(keys, action, desc, mode)
      vim.keymap.set(mode or "n", keys, action, { buffer = event.buf, desc = desc })
    end
    map("gd", function()
      Snacks.picker.lsp_definitions()
    end, "Go to definition")
    map("gr", function()
      Snacks.picker.lsp_references()
    end, "References")
    map("gI", function()
      Snacks.picker.lsp_implementations()
    end, "Implementations")
    map("gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Type definition")
    map("gD", vim.lsp.buf.declaration, "Declaration")
    map("K", vim.lsp.buf.hover, "Documentation")
    map("gK", vim.lsp.buf.signature_help, "Signature help")
    map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
    map("<leader>ss", function()
      Snacks.picker.lsp_symbols()
    end, "Document symbols")
    map("<leader>sS", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "Workspace symbols")
  end,
})
