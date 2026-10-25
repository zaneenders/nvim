-- Run from the config directory: nvim --headless -u NONE -l tests/markdown-preview.lua
local spec = dofile("lua/plugins/markdown-preview.lua")
local fixture = vim.fn.tempname()
vim.fn.mkdir(fixture .. "/autoload/mkdp", "p")
vim.fn.writefile({
  "function! mkdp#util#install() abort",
  "  let g:markdown_preview_installs = get(g:, 'markdown_preview_installs', 0) + 1",
  "endfunction",
}, fixture .. "/autoload/mkdp/util.vim")

local loads = 0
package.loaded["lazy"] = {
  load = function(opts)
    assert(vim.deep_equal(opts.plugins, { "markdown-preview.nvim" }))
    loads = loads + 1
    vim.opt.rtp:prepend(fixture)
  end,
}

local ok, err = pcall(function()
  assert(loads == 0, "Loading the spec must not load the plugin")
  assert(vim.g.markdown_preview_installs == nil)
  spec.build()
  assert(loads == 1, "The build must load the plugin")
  assert(vim.g.markdown_preview_installs == 1, "The build must invoke the autoloaded installer")
end)

vim.fn.delete(fixture, "rf")
assert(ok, err)
print("Markdown Preview build test passed (plugin loaded before installer)")
