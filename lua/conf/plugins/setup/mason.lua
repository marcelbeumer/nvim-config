local M = {}

M.setup = function()
  require("mason").setup({ PATH = "skip" })
end

return M
