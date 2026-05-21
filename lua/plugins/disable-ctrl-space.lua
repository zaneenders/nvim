-- LazyVim maps <C-space> to blink completion (insert/cmdline) and flash.nvim
-- treesitter incremental selection (n/o/x). Remove both so the chord is free.
return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<C-space>"] = false,
      },
      cmdline = {
        keymap = {
          ["<C-space>"] = false,
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    keys = function(_, keys)
      local filtered = {}
      for _, key in ipairs(keys) do
        if not (type(key) == "table" and key[1] == "<c-space>") then
          filtered[#filtered + 1] = key
        end
      end
      return filtered
    end,
  },
}
