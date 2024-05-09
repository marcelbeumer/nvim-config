local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

map("<C-w>N", ":vnew<CR>", "Open new file in vsplit")
map("<C-w>fw", ":set wfw<CR>", "Window fix width")
map("<C-w>fh", ":set wfh<CR>", "Window fix height")
map("]q", ":cnext<CR>", "Next quickfix")
map("[q", ":cprev<CR>", "Previous quickfix")
map("]l", ":lnext<CR>", "Next loclist")
map("[l", ":lprev<CR>", "Previous loclist")
map("]t", ":tabnext<CR>", "Next tab")
map("[t", ":tabprev<CR>", "Previous tab")
map("<C-w>ta", ":tabnew<CR>", "Add tab")
map("<C-w>tc", ":tabclose<CR>", "Close tab")
map("]b", ":bnext<CR>", "Next buffer")
map("[b", ":bprev<CR>", "Previous buffer")

vim.keymap.set("n", "<leader>c", function() 
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = "80"
  else
    vim.o.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn (ruler)" })

vim.keymap.set("n", "<leader>s", function() 
    vim.o.spell = not vim.o.spell
end, { desc = "Toggle spell checker" })
