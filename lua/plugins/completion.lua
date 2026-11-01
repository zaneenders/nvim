return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = { preset = "enter", ["<C-space>"] = false },
    cmdline = { keymap = { ["<C-space>"] = false } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
    -- Avoid a Rust toolchain or a downloaded native completion library.
    fuzzy = { implementation = "lua" },
  },
}
