local M = {}

M.setup = function()
  local env = require("conf.env")

  if env.NVIM_STARTUP == "bare" then
    -- do nothing
  elseif env.NVIM_STARTUP == "plugreg" then
    require("conf.plugins").register()
  elseif env.NVIM_STARTUP == "normal" then
    require("conf.base").setup()
    require("conf.plugins").setup()
    if env.NVIM_LSP == "on" then
      require("conf.lsp").setup()
    end
  end
end

return M
