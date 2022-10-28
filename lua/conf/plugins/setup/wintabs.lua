local M = {}

M.setup = function()
  local get_opts = function(desc)
    return { silent = true, desc = desc }
  end
  vim.keymap.set("n", "<C-/>", ":WintabsClose<CR>", get_opts())
  vim.keymap.set("n", "<C-,>", ":WintabsPrevious<CR>", get_opts())
  vim.keymap.set("n", "<C-.>", ":WintabsNext<CR>", get_opts())
end

return M
