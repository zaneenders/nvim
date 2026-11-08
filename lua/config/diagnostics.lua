local M = {}
local native = vim.diagnostic.handlers.virtual_lines

local function wrap(message, width)
  local lines = {}
  for _, paragraph in ipairs(vim.split(message, "\n", { plain = true })) do
    local line = ""
    for word in paragraph:gmatch("%S+") do
      if line ~= "" and vim.fn.strdisplaywidth(line .. " " .. word) <= width then
        line = line .. " " .. word
      else
        if line ~= "" then
          lines[#lines + 1] = line
        end
        line = ""
        for i = 0, vim.fn.strchars(word, true) - 1 do
          local char = vim.fn.strcharpart(word, i, 1, true)
          if line ~= "" and vim.fn.strdisplaywidth(line .. char) > width then
            lines[#lines + 1] = line
            line = ""
          end
          line = line .. char
        end
      end
    end
    lines[#lines + 1] = line
  end
  return table.concat(lines, "\n")
end

function M.setup()
  vim.diagnostic.handlers.virtual_lines = {
    show = function(namespace, buf, diagnostics, opts)
      local width = math.huge
      for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        width = math.min(width, vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff - 6)
      end
      if width == math.huge or width < 2 then
        return
      end
      -- Only the display copies start at column zero. Underlines and navigation
      -- retain the real locations; six columns are reserved for Neovim's guides.
      diagnostics = vim.deepcopy(diagnostics)
      for _, diagnostic in ipairs(diagnostics) do
        diagnostic.col, diagnostic.end_col = 0, 0
        diagnostic.end_lnum = diagnostic.lnum
        diagnostic.message = wrap(diagnostic.message, width)
      end
      native.show(namespace, buf, diagnostics, opts)
    end,
    hide = native.hide,
  }

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "WinClosed", "WinEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("wrapped_diagnostics", { clear = true }),
    callback = function()
      vim.schedule(function()
        local seen = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if not seen[buf] then
            seen[buf] = true
            vim.api.nvim_win_call(win, function()
              vim.diagnostic.show(nil, buf)
            end)
          end
        end
      end)
    end,
  })
end

return M
