local M = {}

-- register registers all plugins with packer. We are not using packer's APIs
-- to configure plugins or manage their dependencies because explicitly
-- calling a few setup functions and keeping deps implicit keeps the code
-- so much simpler. Also it will be easy to swap packer for something else.
M.register = function()
  local packer = require("packer")
  local util = require("packer.util")
  local use = packer.use

  packer.init({
    snapshot_path = util.join_paths(vim.fn.stdpath("config"), "snapshots"),
  })
  packer.reset()

  -- Packer updates itself.
  use("wbthomason/packer.nvim")
  -- Common plugin dependency.
  use("nvim-lua/plenary.nvim")
  -- Official LSP setup helper plugin, required by lua-dev.
  use("neovim/nvim-lspconfig")
  -- LSP
  use("https://git.sr.ht/~whynothugo/lsp_lines.nvim")
  -- Editor config support.
  use("editorconfig/editorconfig-vim")
  -- Tresitter.
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  -- TypeScript: support different comment styles depending on context.
  use("JoosepAlviste/nvim-ts-context-commentstring")
  -- TypeScript: extra LSP features.
  use("jose-elias-alvarez/nvim-lsp-ts-utils")
  -- File explorer.
  use("kyazdani42/nvim-tree.lua")
  -- Simple session management.
  use("olimorris/persisted.nvim")
  -- Lua dev setup
  use("folke/lua-dev.nvim")
  -- Autocompletion and plugins.
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use({ "hrsh7th/cmp-nvim-lsp-signature-help", commit = "57c4db7" })
  use("saadparwaiz1/cmp_luasnip")
  -- Snippets (required by cmp autocomplete).
  use("L3MON4D3/LuaSnip")
  -- General purpose LSP server, mostly for linting and formatting.
  use("jose-elias-alvarez/null-ls.nvim")
  -- Git.
  use("kdheepak/lazygit.nvim")
  use("tpope/vim-fugitive")
  use("sindrets/diffview.nvim")
  use("lewis6991/gitsigns.nvim")
  -- Quick file/buffer/lsp/etc pickers.
  use("ibhagwan/fzf-lua")
  -- Go specific features.
  -- use("ray-x/go.nvim") -- lots of features
  use("olexsmir/gopher.nvim") -- minimal
  -- Commenting plugin.
  use("terrortylor/nvim-comment")
  -- Automagically insert closing tags etc.
  use("windwp/nvim-autopairs")
  -- Netrw enhancements (mainly for `-`)
  use("tpope/vim-vinegar")
  -- Colorscheme.
  use("marcelbeumer/tokyonight.nvim")
  use({ "catppuccin/nvim", as = "catppuccin" })
  -- Icons.
  use("kyazdani42/nvim-web-devicons")
  -- Code navigation.
  use("simrat39/symbols-outline.nvim")
  -- Motion.
  use("phaazon/hop.nvim")
  -- Debugging.
  use("mfussenegger/nvim-dap")
  use("rcarriga/nvim-dap-ui")
  -- Tests.
  use({ "marcelbeumer/neotest", branch = "output-last" })
  use("haydenmeade/neotest-jest")
  -- UI.
  use("petertriho/nvim-scrollbar")
  use("ThePrimeagen/harpoon")
  use("marcelbeumer/vim-wintabs")
  use("folke/which-key.nvim")
  -- Disabled but here for reference.
  -- use("NvChad/nvim-colorizer.lua")
end

M.setup = function()
  M.register()
  require("conf.plugins.setup.colorscheme").setup()
  require("conf.plugins.setup.cmp").setup()
  require("conf.plugins.setup.treesitter").setup()
  require("conf.plugins.setup.persisted").setup()
  require("conf.plugins.setup.fzf_lua").setup()
  require("conf.plugins.setup.nvim_comment").setup()
  require("conf.plugins.setup.autopairs").setup()
  require("conf.plugins.setup.symbols_outline").setup()
  require("conf.plugins.setup.nvim_tree").setup()
  require("conf.plugins.setup.hop").setup()
  require("conf.plugins.setup.scrollbar").setup()
  require("conf.plugins.setup.gitsigns").setup()
  require("conf.plugins.setup.harpoon").setup()
  require("conf.plugins.setup.wintabs").setup()
  require("conf.plugins.setup.which_key").setup()
  require("conf.plugins.setup.lsp_lines").setup()
  require("conf.plugins.setup.nvim_dap").setup()
  require("conf.plugins.setup.neotest").setup()
  -- require("go").setup()
end

return M
