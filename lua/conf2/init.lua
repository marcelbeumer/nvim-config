local M = {}

M.setup = function()
  require("conf2.base").setup()
  require("conf2.plugins").setup()
  local env = require("conf2.env")
  if env.NVIM_LSP == "on" then
    require("conf2.lsp").setup()
  end
end

return M
