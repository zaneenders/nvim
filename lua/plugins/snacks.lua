return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      hidden = true, -- for hidden files
      ignored = true, -- for .gitignore files
      -- Disable auto root detection to prevent changing cwd to subdirectories
      root = false,
      sources = {
        files = { root = false },
        explorer = { root = false },
        grep = { root = false },
        buffers = { root = false },
      },
    },
    terminal = {
      -- Prevent terminal from changing directories - always use vim's initial cwd
      auto_cwd = false,
      cwd = vim.fn.getcwd(-1, -1),
    },
  },
}
