local M = {}

M.setup = function()
  require("copilot").setup({
    suggestion = {
      auto_trigger = true,
    },
  })
end

return M
