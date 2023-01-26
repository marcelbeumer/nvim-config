local util = require("conf.lsp.util")

local M = {}

M.setup = function()
  require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config
  require("lspconfig").vtsls.setup({
    on_attach = function(client)
      util.disable_formatting(client)
    end,
  })
end

return M
