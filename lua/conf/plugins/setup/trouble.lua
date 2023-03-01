local M = {}

M.setup = function()
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { silent = true }

  require("trouble").setup({})

  bind_all("trouble.toggle", "<cmd>TroubleToggle<cr>", {}, key_opts)
  bind_all("trouble.workspace_diag", "<cmd>TroubleToggle workspace_diagnostics<cr>", {}, key_opts)
  bind_all("trouble.doc_diag", "<cmd>TroubleToggle document_diagnostics<cr>", {}, key_opts)
  bind_all("trouble.loclist", "<cmd>TroubleToggle loclist<cr>", {}, key_opts)
  bind_all("trouble.quickfix", "<cmd>TroubleToggle quickfix<cr>", {}, key_opts)
  bind_all("trouble.lsp_references", "<cmd>TroubleToggle lsp_references<cr>", {}, key_opts)
  bind_all("trouble.lsp_implementations", "<cmd>TroubleToggle lsp_implementations<cr>", {}, key_opts)
  bind_all("trouble.lsp_definitions", "<cmd>TroubleToggle lsp_definitions<cr>", {}, key_opts)
  bind_all("trouble.lsp_type_definitions", "<cmd>TroubleToggle lsp_type_definitions<cr>", {}, key_opts)
end

return M
