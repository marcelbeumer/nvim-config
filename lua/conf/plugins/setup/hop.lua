local M = {}

M.setup = function()
  require("hop").setup()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>w", ":HopWordAC<cr>", opts)
  vim.keymap.set("n", "<leader>W", ":HopWordBC<cr>", opts)
  vim.keymap.set("n", "<leader>o", ":HopWordMW<cr>", opts)
end

return M
