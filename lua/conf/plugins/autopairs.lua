local M = {}

M.setup = function()
	local ts_family_ts_config = { "template_string" }
	require("nvim-autopairs").setup({
		disable_filetype = { "TelescopePrompt", "vim", "markdown" },
		-- added open parentheses ( to the default value
		ignored_next_char = string.gsub([[ [%w%%%'%[%(%"%.] ]], "%s+", ""),
		ts_config = {
			javascript = ts_family_ts_config,
			javascriptreact = ts_family_ts_config,
			typescript = ts_family_ts_config,
			typescriptreact = ts_family_ts_config,
		},
	})
end

return M
