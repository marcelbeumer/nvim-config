vim.cmd([[
  set showbreak=\ 
  augroup ShowbreakToggle
    autocmd!
    autocmd InsertEnter * set showbreak=↪
    autocmd InsertLeave * set showbreak=\ 
  augroup END
]])

vim.cmd([[au BufNewFile,BufRead *.tf set ft=terraform ]])
vim.cmd([[au BufNewFile,BufRead *.hcl,*.terraformrc,terraform.rc set ft=hcl ]])
vim.cmd([[au BufNewFile,BufRead *.tfstate,*.tfstate.backup set ft=json ]])
