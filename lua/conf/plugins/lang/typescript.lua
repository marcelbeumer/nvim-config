return {
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {},
      },
    },
  },
}
