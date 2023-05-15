local M = {}

M.setup = function()
  vim.o.statusline = [[%<%f%{%v:lua.require('conf.plugins.setup.aerial').statusline()%} %h%m%r%=%-14.(%l,%c%V%) %P]]
end

return M
