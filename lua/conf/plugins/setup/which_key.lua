local M = {}

M.setup = function()
  vim.o.timeoutlen = 500
  require("which-key").setup()
end

return M
