local M = {}

M.register = function()
	local packer = require("packer")
	local use = packer.use
	packer.init()
	packer.reset()

	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("NTBBloodbath/color-converter.nvim")
	use("RRethy/nvim-treesitter-textsubjects")
	use("editorconfig/editorconfig-vim")
	use("folke/lua-dev.nvim")
	use("folke/persistence.nvim")
	use("folke/tokyonight.nvim")
	use("folke/which-key.nvim")
	use("folke/zen-mode.nvim")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/vim-vsnip")
	-- pin null-ls: issue on my outdated 0.8, need to upgrade closer to HEAD
	use({ "jose-elias-alvarez/null-ls.nvim", commit = "d871b418c67867a11a43eb1412a1a21aee888ae3" })
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("kazhala/close-buffers.nvim")
	use("kdheepak/lazygit.nvim")
	use("leoluz/nvim-dap-go")
	use("mfussenegger/nvim-dap")
	use("neovim/nvim-lspconfig")
	use("norcalli/nvim-colorizer.lua")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("nvim-telescope/telescope.nvim")
	use("nvim-treesitter/nvim-treesitter")
	use("preservim/nerdtree")
	use("rafcamlet/nvim-luapad")
	use("ray-x/go.nvim")
	use("rcarriga/nvim-dap-ui")
	use("rmagatti/goto-preview")
	use("sbdchd/neoformat")
	use("terrortylor/nvim-comment")
	use("tpope/vim-fugitive")
	use("tpope/vim-surround")
	use("wbthomason/packer.nvim")
	use("windwp/nvim-autopairs")
end

M.setup = function()
	M.register()

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
