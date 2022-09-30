local M = {}

M.setup = function()
  vim.o.ruler = false -- this way ctrl-g will show line+col
  local get_opts = function(desc)
    return { desc = desc }
  end
  vim.keymap.set("n", "<C-x>", ":WintabsClose<CR>", get_opts())
  vim.keymap.set("n", "<C-L>", ":WintabsNext<CR>", get_opts())
  vim.keymap.set("n", "<C-H>", ":WintabsPrevious<CR>", get_opts())
end

return M
