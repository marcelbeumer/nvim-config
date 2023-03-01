local M = {}

M.setup = function()
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  require("symbols-outline").setup({})
  bind_all("symbols_outline.toggle", "<cmd>SymbolsOutline<cr>", {}, key_opts)
end

return M
