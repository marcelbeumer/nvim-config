local M = {}

M.setup = function()
  vim.keymap.set("n", "<C-/>", ":BDelete this<CR>", { silent = true })
end

return M
