local M = {}

M.setup = function()
  require("neodev").setup({})
  local lspconfig = require("lspconfig")
  lspconfig.sumneko_lua.setup({
    settings = {
      Lua = {
        completion = {
          showWord = "Disable",
          callSnippet = "Disable",
          keywordSnippet = "Disable",
        },
      },
    },
  })
end

return M
