return {
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "yioneko/nvim-vtsls",
    },
    opts = {
      servers = {
        vtsls = function()
          if require("conf.env").NVIM_TS_LSP == "vtsls" then
            return {}
          end
        end,
      },
    },
  },

  {
    "yioneko/nvim-vtsls",
    opts = {},
    config = function()
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
      },
    },
  },
}
