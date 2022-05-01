local M = {}

M.setup = function()
	-- Add gotmpl support
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	parser_config.gotmpl = {
		install_info = {
			url = "https://github.com/ngalaiko/tree-sitter-go-template",
			files = { "src/parser.c" },
		},
		filetype = "gotmpl",
		used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
	}

	-- Get parser names (filtered)
	local parser_names = {}
	local exclude_parsers = {
		"phpdoc", -- Does not compile on Apple M1
	}
	local parsers = require("nvim-treesitter.parsers").get_parser_configs()
	for k, _ in pairs(parsers) do
		if not vim.tbl_contains(exclude_parsers, k) then
			table.insert(parser_names, k)
		end
	end

	-- Setup treesitter itself
	require("nvim-treesitter.configs").setup({
		ensure_installed = parser_names,
		indent = { enable = false }, -- indenting is too quirky still
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		highlight = { enable = true },
		textsubjects = {
			enable = true,
			keymaps = {
				["."] = "textsubjects-smart",
				[";"] = "textsubjects-container-outer",
				["i;"] = "textsubjects-container-inner",
			},
		},
	})

	vim.cmd([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set foldlevelstart=99
  ]])
end

return M
