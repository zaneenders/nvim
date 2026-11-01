return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({})
    if vim.fn.executable("tree-sitter") == 1 then
      ts.install({
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "swift",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(event)
        -- Fall back to Vim syntax until the parser is installed.
        pcall(vim.treesitter.start, event.buf)
      end,
    })
  end,
}
