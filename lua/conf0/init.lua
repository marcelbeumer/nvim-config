local M = {}

M.setup = function()
  local env = require("conf0.env")

  if env.NVIM_STARTUP == "safe" then
    -- do nothing
  elseif env.NVIM_STARTUP == "base" then
    require("conf0.dev").setup()
    require("conf0.base").setup()
  elseif env.NVIM_STARTUP == "normal" then
    require("conf0.globals").setup()
    require("conf0.bindings").setup()
    require("conf0.base").setup()
    require("conf0.fs").setup()
    require("conf0.layout").setup()
    require("conf0.panels").setup()
    require("conf0.plugins").setup()
    require("conf0.diagnostic").setup()
    if env.NVIM_LSP == "on" then
      require("conf0.lsp").setup()
    end
    require("conf0.colorscheme").setup()
  end
end

return M
