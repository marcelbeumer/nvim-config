return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "yioneko/nvim-vtsls", -- vtsls, typescript
    },
    config = function(_, opts)
      require("conf.lsp").setup()
    end,
  },
}
