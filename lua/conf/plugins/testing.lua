return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      adapters = {},
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
