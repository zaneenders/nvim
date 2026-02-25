return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      hidden = true, -- for hidden files
      ignored = true, -- for .gitignore files
      -- Disable auto root detection to prevent changing cwd to subdirectories
      root = false,
    },
    terminal = {
      -- Prevent terminal from changing directories - always use vim's initial cwd
      cwd = vim.fn.getcwd(-1, -1),
    },
  },
}
