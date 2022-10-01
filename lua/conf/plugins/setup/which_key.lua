local M = {}

M.setup = function()
  local wk = require("which-key")
  vim.o.timeoutlen = 500
  wk.setup({
    plugins = {
      spelling = {
        enabled = true,
      },
    },
  })
end

return M
