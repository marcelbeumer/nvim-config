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

-- Tabline show/hide
vim.api.nvim_create_user_command("TablineShow", function()
  vim.o.showtabline = 2
end, {})
vim.api.nvim_create_user_command("TablineHide", function()
  vim.o.showtabline = 0
end, {})

vim.api.nvim_create_user_command("ColorSchemeNext", function()
  require("conf.util.theme_cycler")()
end, {})
