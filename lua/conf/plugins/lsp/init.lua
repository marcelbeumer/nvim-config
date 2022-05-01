local M = {}

function M.setup()
  -- vim.lsp.set_log_level("debug")
  require("goto-preview").setup({})
  require("conf.plugins.lsp.diagnostic").setup()
  require("conf.plugins.lsp.servers").setup()
end

return M
