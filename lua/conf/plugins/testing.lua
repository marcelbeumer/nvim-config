return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-go",
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diag)
            return diag.ressage:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          end,
        },
      }, ns)
      require("neotest").setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            -- args = { "-count=1", "-timeout=60s" },
          }),
        },
      })
    end,
  },
}
