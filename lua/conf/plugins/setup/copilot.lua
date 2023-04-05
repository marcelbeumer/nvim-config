local M = {}

M.setup = function()
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
