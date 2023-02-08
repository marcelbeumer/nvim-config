local M = {}

M.setup = function()
  vim.keymap.set("n", "zR", require("ufo").openAllFolds)
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
  require("ufo").setup()
end

return M
