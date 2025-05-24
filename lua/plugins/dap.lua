return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")

      local lldb_dap_path = vim.fn.trim(vim.fn.system("xcrun -f lldb-dap"))

      dap.adapters.swift = {
        type = "server",
        port = "${port}",
        executable = {
          command = lldb_dap_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.swift = {
        {
          name = "Launch Swift Exectuable",
          type = "swift",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executuable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
    end,
  },
}
