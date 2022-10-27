local M = {}

M.setup = function()
  require("persisted").setup({
    branch_separator = "@@"
  })
end

return M
