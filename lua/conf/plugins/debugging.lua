return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    opts = {
      adapters = {},
      configurations = {},
    },
    keys = {
      { "<leader><leader>u", "<cmd>lua require('dapui').toggle()<cr>", desc = "DAP toggle UI" },
      { "<leader><leader>r", "<cmd>lua require('dap').continue()<cr>", desc = "DAP continue" },
      { "<leader><leader>R", "<cmd>lua require('dap').run_last()<cr>", desc = "DAP run last" },
      { "<leader><leader>x", "<cmd>lua require('dap').terminate()<cr>", desc = "DAP terminate" },
      { "<leader><leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "DAP breakpoint toggle" },
      {
        "<leader><leader>B",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP breakpoint condition",
      },
      {
        "<leader><leader>L",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "DAP breakpoint log message",
      },
      { "<leader><leader>l", "<cmd>lua require('dap').step_over()<cr>", desc = "DAP step over" },
      { "<leader><leader>j", "<cmd>lua require('dap').step_into()<cr>", desc = "DAP step into" },
      { "<leader><leader>k", "<cmd>lua require('dap').step_out()<cr>", desc = "DAP step out" },
    },
    config = function(_, opts)
      local dap = require("dap")
      dap.adapters = opts.adapters
      dap.configurations = opts.configurations

      local dapui = require("dapui")
      dapui.setup()

      vim.api.nvim_create_user_command("LoadLaunchJSON", function(input)
        local filename = input.args ~= "" and input.args or ".vscode/launch.json"
        require("dap.ext.vscode").load_launchjs(filename)
      end, { nargs = "?" })

      vim.api.nvim_create_user_command("DAPClearBreakpoints", dap.clear_breakpoints, {})

      vim.keymap.set("v", "<M-k>", dapui.eval, { desc = "DAP evaluate visually selected" })
    end,
  },
}
