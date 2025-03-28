vim.cmd([[
  set showbreak=\ 
  augroup ShowbreakToggle
    autocmd!
    autocmd InsertEnter * set showbreak=↪
    autocmd InsertLeave * set showbreak=\ 
  augroup END
]])
