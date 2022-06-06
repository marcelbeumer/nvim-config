local M = {}

M.setup = function()
  require("conf.base").setup()
  require("conf.plugins").setup()
  local env = require("conf.env")
  if env.NVIM_LSP == "on" then
    require("conf.lsp").setup()
  end
end

return M
