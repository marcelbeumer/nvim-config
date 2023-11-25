return {
  {
    "folke/neodev.nvim",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neodev.nvim" },
    opts = {
      servers = {
        lua_ls = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
