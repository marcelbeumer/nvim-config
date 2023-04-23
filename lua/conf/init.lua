local M = {}

M.setup = function()
  local env = require("conf.env")

  if env.NVIM_STARTUP == "safe" then
    -- do nothing
  elseif env.NVIM_STARTUP == "base" then
    require("conf.dev").setup()
    require("conf.base").setup()
  elseif env.NVIM_STARTUP == "normal" then
    require("conf.globals").setup()
    require("conf.bindings").setup()
    require("conf.base").setup()
    require("conf.fs").setup()
    require("conf.layout").setup()
    require("conf.panels").setup()
    require("conf.plugins").setup()
    require("conf.diagnostic").setup()
    if env.NVIM_LSP == "on" then
      require("conf.lsp").setup()
    end
    require("conf.colorscheme").setup()
  end
end

return M
