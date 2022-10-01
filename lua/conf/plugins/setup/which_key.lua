local M = {}

M.setup = function()
  vim.o.timeoutlen = 500
  require("which-key").setup({
    triggers = { "<leader>" },
    plugins = {
      spelling = {
        enabled = true,
      },
    },
  })
end

return M
