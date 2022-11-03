local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  require("symbols-outline").setup({})
  bind_all("symbols_outline.toggle", "<cmd>SymbolsOutline<cr>", cmd_opts, key_opts)
end

return M
