return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        print(sign[1])
        vim.fn.sign_define(
          "Dap" .. name,
          { texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3], text = sign[1] }
        )
      end

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
