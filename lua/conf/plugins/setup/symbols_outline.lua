local M = {}

M.setup = function()
  require("symbols-outline").setup({})
  vim.keymap.set("n", "<leader>/", "<cmd>SymbolsOutline<cr>", {})
end

return M
