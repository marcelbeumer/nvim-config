local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { silent = true }
  local cmd_opts = {}

  require("trouble").setup({})

  bind_all("trouble.toggle", "<cmd>TroubleToggle<cr>", cmd_opts, key_opts)
  bind_all("trouble.workspace_diag", "<cmd>TroubleToggle workspace_diagnostics<cr>", cmd_opts, key_opts)
  bind_all("trouble.doc_diag", "<cmd>TroubleToggle document_diagnostics<cr>", cmd_opts, key_opts)
  bind_all("trouble.loclist", "<cmd>TroubleToggle loclist<cr>", cmd_opts, key_opts)
  bind_all("trouble.quickfix", "<cmd>TroubleToggle quickfix<cr>", cmd_opts, key_opts)
  bind_all("trouble.lsp_references", "<cmd>TroubleToggle lsp_references<cr>", cmd_opts, key_opts)
  bind_all("trouble.lsp_definitions", "<cmd>TroubleToggle lsp_definitions<cr>", cmd_opts, key_opts)
  bind_all("trouble.lsp_type_definitions", "<cmd>TroubleToggle lsp_type_definitions<cr>", cmd_opts, key_opts)
end

return M
