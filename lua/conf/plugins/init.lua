local M = {}

M.register = function()
  local packer = require("packer")
  local use = packer.use
  packer.init()
  packer.reset()

  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("NTBBloodbath/color-converter.nvim")
  use("RRethy/nvim-treesitter-textsubjects")
  use("simrat39/symbols-outline.nvim")
  use("editorconfig/editorconfig-vim")
  use("folke/lua-dev.nvim")
  use("folke/persistence.nvim")
  use("folke/tokyonight.nvim")
  use("folke/which-key.nvim")
  use("folke/zen-mode.nvim")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use("hrsh7th/nvim-cmp")
  use("L3MON4D3/LuaSnip")
  -- disable vim-ultest: sometimesm get errors of things that run on interval?
  -- use({ "rcarriga/vim-ultest", requires = { "vim-test/vim-test" }, run = ":UpdateRemotePlugins" })
  -- pin null-ls: issue with 0.8 (null-ls/client.lua:39: bad argument #1 to 'unpack' (table expected, got string))
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
  use("ray-x/guihua.lua")
  use("rcarriga/nvim-dap-ui")
  use("rmagatti/goto-preview")
  use("saadparwaiz1/cmp_luasnip")
  use("sbdchd/neoformat")
  use("terrortylor/nvim-comment")
  use("tpope/vim-abolish")
  use("tpope/vim-fugitive")
  use("tpope/vim-surround")
  use("wbthomason/packer.nvim")
  use("windwp/nvim-autopairs")
end

M.setup = function()
  local env = require("conf.env")
  M.register()

  require("which-key").setup({})
  require("zen-mode").setup({ width = 80 })
  require("dap-go").setup()
  require("dapui").setup()
  require("go").setup()
  require("conf.plugins.autopairs").setup()
  require("conf.plugins.cmp").setup()
  require("conf.plugins.color_converter").setup()
  if env.NVIM_LSP == "on" then
    require("conf.plugins.lsp").setup()
  end
  require("conf.plugins.nerd").setup()
  require("conf.plugins.nvim_comment").setup()
  require("conf.plugins.persistence").setup()
  require("conf.plugins.telescope").setup()
  require("conf.plugins.treesitter").setup()

  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_italic_comments = false
  vim.g.tokyonight_italic_keywords = false
  vim.cmd([[colorscheme tokyonight]])
end

return M
