return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
    },
    -- Extend LazyVim's debugger setup so Mason and launch.json support still run.
    opts = function()
      local lldb_dap_path = vim.fn.exepath("lldb-dap")
      if lldb_dap_path == "" and vim.fn.has("macunix") == 1 and vim.fn.executable("xcrun") == 1 then
        lldb_dap_path = vim.fn.trim(vim.fn.system({ "xcrun", "-f", "lldb-dap" }))
        if vim.v.shell_error ~= 0 then
          return
        end
      end
      if lldb_dap_path == "" or vim.fn.executable(lldb_dap_path) == 0 then
        return
      end

      local dap = require("dap")
      dap.adapters.swift = {
        type = "executable",
        command = lldb_dap_path,
      }
      dap.configurations.swift = {
        {
          name = "Launch Swift Executable",
          type = "swift",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Attach to process",
          type = "swift",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }
    end,
  },
}
