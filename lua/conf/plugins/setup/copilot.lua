local M = {}

M.setup = function()
  local env = require("conf.env")
  if env.NVIM_ENABLE_COPILOT ~= "on" then
    return
  end

  require("copilot").setup({
    suggestion = {
      auto_trigger = true,
    },
    panel = {
      auto_refresh = true,
    },
  })
end

return M
