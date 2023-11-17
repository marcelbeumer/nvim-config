local util = require("conf0.lsp.util")

local M = {}

M.setup = function()
  require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config
  require("lspconfig").vtsls.setup({
    handlers = util.get_handlers(),
    capabilities = util.get_capabilities(),
    on_attach = function(client)
      util.disable_formatting(client)
    end,
  })
end

return M
