local M = {}

function M.setup()
	require("goto-preview").setup({})
	require("conf.plugins.lsp.diagnostic").setup()
	require("conf.plugins.lsp.servers").setup()
end

return M
