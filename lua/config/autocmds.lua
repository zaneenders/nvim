-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Store the initial working directory when nvim starts
vim.g.nvim_initial_cwd = vim.fn.getcwd()

-- Prevent directory changes when opening Package.swift or other project files
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.swift",
  callback = function()
    -- Don't change directory when opening Package.swift files
    local filename = vim.fn.expand("%:t")
    if filename == "Package.swift" then
      vim.cmd("lcd " .. vim.g.nvim_initial_cwd)
    end
  end,
})

-- Treat Metal shaders as C++ for syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.metal",
  callback = function()
    vim.bo.filetype = "cpp"
  end,
})

-- Detach LSP clients from Metal buffers: clangd and sourcekit cannot
-- handle Metal-specific syntax (e.g. metal_stdlib, [[buffer(n)]])
-- and will spam "invalid AST" errors if left attached.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    if bufname:match("%.metal$") then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        vim.schedule(function()
          vim.lsp.buf_detach_client(args.buf, client.id)
        end)
      end
    end
  end,
})
