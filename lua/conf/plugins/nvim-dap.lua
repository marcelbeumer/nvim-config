return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    opts = {
      adapters = {
        go = {
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        },
      },
      configurations = {
        go = {
          {
            type = "go",
            name = "Debug (file)",
            request = "launch",
            program = "${file}",
          },
          -- configuration for debugging test files
          {
            type = "go",
            name = "Debug test (file)",
            request = "launch",
            mode = "test",
            program = "${file}",
          },
          -- works with go.mod packages and sub packages
          {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
          },
          {
            type = "go",
            name = "Debug test w/ args (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
            args = function()
              return coroutine.create(function(co)
                local default = _G.__go_dlv_last_args or "-test.run=TestXXX"
                vim.ui.input({ prompt = "dlv args:", default = default }, function(args)
                  _G.__go_dlv_last_args = args
                  coroutine.resume(co, vim.split(_G.__go_dlv_last_args, " "))
                end)
              end)
            end,
          },
        },
      },
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
      local icons = require("conf.icons")
      local dap = require("dap")
      dap.adapters = opts.adapters
      dap.configurations = opts.configurations

      vim.fn.sign_define("DapBreakpoint", {
        text = icons.ui.Bug,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = icons.ui.Bug,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = icons.ui.Bug,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

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
