local M = {}

function M.run(command, description)
  local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local spinner_idx = 1
  local timer = nil
  local notification_id = nil
  local stderr_lines = {}

  local function update_spinner()
    notification_id =
      vim.notify(spinner_frames[spinner_idx] .. " Scribe: " .. description .. "...", vim.log.levels.INFO, {
        replace = notification_id,
        title = "Scribe",
        icon = "📝",
      })
    spinner_idx = (spinner_idx % #spinner_frames) + 1
  end

  -- Show initial spinner
  notification_id = vim.notify(
    spinner_frames[1] .. " Scribe: " .. description .. "...",
    vim.log.levels.INFO,
    { title = "Scribe", icon = "📝" }
  )

  local job_id = vim.fn.jobstart({ "scribe", command }, {
    on_exit = function(_, exit_code)
      if timer then
        timer:stop()
        timer:close()
      end
      -- Force reload all loaded buffers (discards any unsaved changes!)
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("edit!")
          end)
        end
      end
      if exit_code == 0 then
        vim.notify("✓ Scribe: " .. description .. " complete", vim.log.levels.INFO, {
          replace = notification_id,
          title = "Scribe",
          icon = "📝",
        })
      else
        local msg = "✗ Scribe: " .. description .. " failed (exit " .. exit_code .. ")"
        if #stderr_lines > 0 then
          msg = msg .. "\n" .. table.concat(stderr_lines, "\n")
        end
        vim.notify(msg, vim.log.levels.ERROR, {
          replace = notification_id,
          title = "Scribe",
          icon = "📝",
        })
      end
    end,
    on_stderr = function(_, data)
      -- Collect stderr for error reporting only (scribe outputs trace logs here)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(stderr_lines, line)
          end
        end
      end
    end,
  })

  if job_id > 0 then
    timer = vim.uv.new_timer()
    timer:start(100, 100, vim.schedule_wrap(update_spinner))
  else
    vim.notify("Failed to start scribe " .. command, vim.log.levels.ERROR)
  end
end

return M
