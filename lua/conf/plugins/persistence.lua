local M = {}

M.setup = function()
	require("persistence").setup({
		dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
	})
	vim.cmd([[
    command! LoadSession lua require("persistence").load()<cr>
    command! SaveSession lua require("persistence").save()<cr>
    command! StopSession lua require("persistence").stop()<cr>
  ]])
end

return M
