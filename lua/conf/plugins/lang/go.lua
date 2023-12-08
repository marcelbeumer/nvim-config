return {
  { "olexsmir/gopher.nvim" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          init_options = {
            buildFlags = { "-tags=integration" },
          },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofumpt" },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        go = function()
          return require("neotest-go")({
            experimental = {
              test_table = true,
            },
            -- args = { "-count=1", "-timeout=60s" },
          })
        end,
      },
    },
  },
}
