local M = {}

M.setup = function()
  require("yanky").setup({
    highlight = {
      timer = 150,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  })

  vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
  vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
  vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
end

return M
