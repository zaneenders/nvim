-- Run with the real config/plugins: nvim --headless -i NONE -c "lua dofile('tests/smoke.lua')"
local fixture = vim.fn.tempname()
local original_cwd = vim.fn.getcwd()

local function wait_for(message, predicate, timeout)
  assert(vim.wait(timeout or 10000, predicate, 20), message)
end

local function picker_items(picker)
  wait_for("Picker did not finish", function()
    return not picker.finder:running() and not picker.matcher:running()
  end)
  local names = {}
  for _, item in ipairs(picker:items()) do
    if item.file then
      names[vim.fs.basename(item.file)] = true
    end
  end
  picker:close()
  return names
end

local function run()
  assert(not require("lazy.core.config").plugins.LazyVim, "LazyVim must not be configured")
  assert(not package.loaded["lazyvim"], "LazyVim must not be loaded")
  assert(not package.loaded["mason"], "Mason must not be loaded")
  assert(not require("lazy.core.config").plugins["conform.nvim"], "Conform must not be configured")
  assert(not require("lazy.core.config").plugins["tokyonight.nvim"], "Theme must be local")
  assert(vim.g.colors_name == "local-night", "Local colorscheme must be active")
  for _, tool in ipairs({
    "clangd",
    "tree-sitter",
  }) do
    local path = vim.fn.exepath(tool)
    assert(path ~= "", "Missing system tool: " .. tool)
    assert(not path:find("/mason/", 1, true), tool .. " must come from a system installation")
  end
  assert(vim.v.errmsg == "", vim.v.errmsg)

  vim.fn.mkdir(fixture .. "/ignored", "p")
  vim.fn.writefile({ "ignored/" }, fixture .. "/.gitignore")
  vim.fn.writefile({ "nvim_smoke_needle" }, fixture .. "/visible.txt")
  vim.fn.writefile({ "nvim_smoke_needle" }, fixture .. "/.hidden.txt")
  vim.fn.writefile({ "nvim_smoke_needle" }, fixture .. "/ignored/secret.txt")
  assert(vim.system({ "git", "init", "--quiet", fixture }):wait().code == 0)
  vim.cmd.cd(fixture)

  local files = picker_items(Snacks.picker.files({ cwd = fixture, enter = false, show_delay = 0 }))
  assert(files["visible.txt"] and files[".hidden.txt"], "File search must include hidden files: " .. vim.inspect(files))
  assert(not files["secret.txt"], "File search must respect gitignore")

  local grep = picker_items(Snacks.picker.grep({
    cwd = fixture,
    search = "nvim_smoke_needle",
    enter = false,
    show_delay = 0,
  }))
  assert(grep["visible.txt"] and grep[".hidden.txt"], "Grep must find normal and hidden files")
  assert(not grep["secret.txt"], "Grep must respect gitignore")

  local explorer = picker_items(Snacks.explorer({
    cwd = fixture,
    pattern = "visible",
    enter = false,
    show_delay = 0,
    watch = false,
    git_status = false,
    diagnostics = false,
  }))
  assert(explorer["visible.txt"], "Explorer recursive search must work")
  print("File search, live grep, and explorer passed")

  vim.fn.writefile({ "int answer=42;", "int result=answer;", "int main() { ans" }, fixture .. "/main.cpp")
  vim.cmd.edit(fixture .. "/main.cpp")
  local bufnr = vim.api.nvim_get_current_buf()
  local client
  wait_for("clangd did not attach", function()
    client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
    return client and client.initialized
  end, 20000)
  assert(#vim.lsp.get_clients({ bufnr = bufnr }) == 1, "Only one C++ server should attach")
  local uri = vim.uri_from_bufnr(bufnr)
  local definition = client:request_sync("textDocument/definition", {
    textDocument = { uri = uri },
    position = { line = 1, character = 15 },
  }, 10000, bufnr)
  assert(definition and definition.result and #definition.result > 0, "Definition lookup failed")
  local completion = client:request_sync("textDocument/completion", {
    textDocument = { uri = uri },
    position = { line = 2, character = 15 },
  }, 10000, bufnr)
  local items = completion and completion.result and (completion.result.items or completion.result)
  assert(items and #items > 0, "LSP completion failed")
  assert(vim.fn.maparg("gd", "n", false, true).buffer == 1, "LSP navigation keys must be attached")
  print("C++ LSP definition and completion passed")

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "int answer=42;" })
  vim.cmd.write()
  assert(vim.fn.readfile(fixture .. "/main.cpp")[1] == "int answer = 42;", "Format on save failed")
  vim.fn.maparg("<leader>uf", "n", false, true).callback()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "int answer=43;" })
  vim.cmd.write()
  assert(vim.fn.readfile(fixture .. "/main.cpp")[1] == "int answer=43;", "Format toggle failed")
  vim.fn.maparg("<leader>cf", "n", false, true).callback()
  wait_for("Manual LSP formatting failed", function()
    return vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == "int answer = 43;"
  end)
  vim.cmd.write()
  vim.g.disable_autoformat = false
  print("Native LSP formatting, manual formatting, and toggle passed")

  local samples = {
  }
  if vim.lsp.is_enabled("sourcekit") then
    samples[#samples + 1] = { "main.swift", "let answer = 42", "sourcekit" }
  end
  for _, sample in ipairs(samples) do
    vim.fn.writefile({ sample[2] }, fixture .. "/" .. sample[1])
    vim.cmd.edit(fixture .. "/" .. sample[1])
    local buf = vim.api.nvim_get_current_buf()
    wait_for(sample[3] .. " did not attach", function()
      local attached = vim.lsp.get_clients({ bufnr = buf, name = sample[3] })[1]
      return attached and attached.initialized
    end, 20000)
    assert(#vim.lsp.get_clients({ bufnr = buf }) == 1, "Unexpected duplicate servers on " .. sample[1])
    print(sample[3] .. " attached successfully")
  end

  vim.cmd.edit(fixture .. "/shader.metal")
  assert(vim.bo.filetype == "metal", "Metal must have a separate filetype")
  assert(vim.treesitter.language.get_lang("metal") == "cpp", "Metal must use C++ highlighting")
  vim.wait(200)
  assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, "Metal must not attach an LSP")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "// No formatting server for Metal" })
  vim.cmd.write()
  assert(vim.fn.readfile(fixture .. "/shader.metal")[1] == "// No formatting server for Metal")
  assert(vim.uv.fs_realpath(vim.fn.getcwd()) == vim.uv.fs_realpath(fixture), "Navigation must preserve cwd")
  for _, server in ipairs({ "lua_ls", "vtsls", "html", "cssls", "ts_ls" }) do
    assert(not vim.lsp.is_enabled(server), server .. " must not be enabled")
  end
  print("Metal isolation and cwd passed")
end

vim.schedule(function()
  local ok, err = xpcall(run, debug.traceback)
  for _, picker in ipairs(Snacks.picker.get()) do
    picker:close()
  end
  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop(true)
  end
  vim.cmd.cd(original_cwd)
  vim.fn.delete(fixture, "rf")
  if not ok then
    vim.api.nvim_err_writeln(err)
    vim.cmd.cquit(1)
  else
    print("Smoke tests passed")
    vim.cmd.qa({ bang = true })
  end
end)
