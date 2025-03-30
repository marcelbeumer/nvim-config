return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    opts = {
      linters_by_ft = {
        -- go = { "golangcilint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
