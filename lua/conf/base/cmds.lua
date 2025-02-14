-- W for all those typos.
vim.cmd([[command W w]])

vim.cmd([[
  function! DateStrPretty() range
    return system('date "+%Y-%m-%d %H:%M:%S" | tr -d "\n"')
  endfunction

  function! DateStrFs() range
    return system('date "+%Y-%m-%d-%H%M-%S" | tr -d "\n"')
  endfunction
]])
