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
      -- { "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
    },
    config = function(_, opts)
      local dap = require("dap")
      dap.adapters = opts.adapters
      dap.configurations = opts.configurations

      vim.api.nvim_create_user_command("LoadLaunchJSON", function(input)
        local filename = input.args ~= "" and input.args or ".vscode/launch.json"
        require("dap.ext.vscode").load_launchjs(filename)
      end, { nargs = "?" })
    end,
  },
}
