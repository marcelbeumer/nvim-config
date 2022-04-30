local M = {}

M.setup = function()
	local packages = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"NTBBloodbath/color-converter.nvim",
		"RRethy/nvim-treesitter-textsubjects",
		"editorconfig/editorconfig-vim",
		"folke/lua-dev.nvim",
		"folke/persistence.nvim",
		"folke/tokyonight.nvim",
		"folke/which-key.nvim",
		"folke/zen-mode.nvim",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/nvim-cmp",
		"hrsh7th/vim-vsnip",
		"jose-elias-alvarez/null-ls.nvim",
		"jose-elias-alvarez/nvim-lsp-ts-utils",
		"kazhala/close-buffers.nvim",
		"kdheepak/lazygit.nvim",
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap",
		"neovim/nvim-lspconfig",
		"norcalli/nvim-colorizer.lua",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzy-native.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
		"preservim/nerdtree",
		"rafcamlet/nvim-luapad",
		"ray-x/go.nvim",
		"rcarriga/nvim-dap-ui",
		"rmagatti/goto-preview",
		"sbdchd/neoformat",
		"terrortylor/nvim-comment",
		"tpope/vim-fugitive",
		"tpope/vim-surround",
		"wbthomason/packer.nvim",
		"windwp/nvim-autopairs",
	}

	require("paq")(packages)
	require("which-key").setup({})
	require("zen-mode").setup({ width = 80 })
	require("dap-go").setup()
	require("dapui").setup()
	require("go").setup()
	require("conf.plugins.autopairs").setup()
	require("conf.plugins.cmp").setup()
	require("conf.plugins.color_converter").setup()
	require("conf.plugins.lsp").setup()
	require("conf.plugins.nerd").setup()
	require("conf.plugins.nvim_comment").setup()
	require("conf.plugins.persistence").setup()
	require("conf.plugins.telescope").setup()
	require("conf.plugins.treesitter").setup()
	require("conf.plugins.vsnip").setup()

	vim.g.tokyonight_style = "night"
	vim.g.tokyonight_italic_comments = false
	vim.g.tokyonight_italic_keywords = false
	vim.cmd([[colorscheme tokyonight]])
end

return M
