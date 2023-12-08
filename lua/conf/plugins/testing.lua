return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      adapters = {},
    },
    keys = {
      { "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
      { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run last test" },
      { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Output panel toggle" },
      { "<leader>tc", "<cmd>lua require('neotest').output_panel.clear()<cr>", desc = "Output panel clear" },
      { "<leader>tx", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop nearest test" },
      { "<leader>t/", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Test summary toggle" },
    },
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diag)
            return diag.ressage:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, ns)
      local adapters = {}
      for _, fn in pairs(opts.adapters) do
        table.insert(adapters, fn(opts))
      end
      require("neotest").setup({
        adapters = adapters,
      })
    end,
  },
}
