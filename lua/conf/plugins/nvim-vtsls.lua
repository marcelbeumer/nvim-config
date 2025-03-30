return {
  {
    "yioneko/nvim-vtsls",
    opts = {},
    config = function()
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    end,
  },
}
