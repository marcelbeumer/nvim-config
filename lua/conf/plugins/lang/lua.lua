return {
  {
    "folke/neodev.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {},
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
