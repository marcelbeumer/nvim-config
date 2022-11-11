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
  -- Project switching.
  use({ "marcelbeumer/project.nvim", branch = "remove-fixed-widths" })
  -- Lua dev setup
  use("folke/neodev.nvim")
  -- Autocompletion and plugins.
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use({ "hrsh7th/cmp-nvim-lsp-signature-help", commit = "57c4db7" })
  use("saadparwaiz1/cmp_luasnip")
  -- Snippets (required by cmp autocomplete).
  use("L3MON4D3/LuaSnip")
  -- General purpose LSP server, mostly for linting and formatting.
  -- use("jose-elias-alvarez/null-ls.nvim")
  use({ "marcelbeumer/null-ls.nvim", branch = "fix-golangci-lint" })
  -- Git.
  use("kdheepak/lazygit.nvim")
  use("tpope/vim-fugitive")
  use("sindrets/diffview.nvim")
  use("lewis6991/gitsigns.nvim")
  use("akinsho/git-conflict.nvim")
  -- Quick file/buffer/lsp/etc pickers.
  use("ibhagwan/fzf-lua")
  -- Go specific features.
  -- use("ray-x/guihua.lua")
  -- use("ray-x/go.nvim") -- lots of features
  use("olexsmir/gopher.nvim") -- minimal
  -- use("crusj/structrue-go.nvim")
  -- Commenting plugin.
  use("terrortylor/nvim-comment")
  -- Automagically insert closing tags etc.
  use("windwp/nvim-autopairs")
  -- Colorscheme.
  use("folke/tokyonight.nvim")
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
  use("mxsdev/nvim-dap-vscode-js")
  use({
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npm run compile",
  })
  use("theHamsta/nvim-dap-virtual-text")
  -- Tests.
  use({ "marcelbeumer/neotest", branch = "output-last" })
  use("haydenmeade/neotest-jest")
  -- UI.
  use("rafcamlet/tabline-framework.nvim")
  use("petertriho/nvim-scrollbar")
  use({ "marcelbeumer/harpoon", branch = "fix/no-absolute-path" })
  use("folke/which-key.nvim")
  -- Buffer management.
  use("kazhala/close-buffers.nvim")
  -- Improved Yank/put.
  use("gbprod/yanky.nvim")
  -- Disabled but here for reference.
  -- use("NvChad/nvim-colorizer.lua")
end

M.setup = function()
  M.register()
  require("conf.plugins.setup.yanky").setup()
  require("conf.plugins.setup.colorscheme").setup()
  require("conf.plugins.setup.cmp").setup()
  require("conf.plugins.setup.treesitter").setup()
  require("conf.plugins.setup.lazygit").setup()
  require("conf.plugins.setup.persisted").setup()
  require("conf.plugins.setup.fzf_lua").setup()
  require("conf.plugins.setup.project_nvim").setup()
  require("conf.plugins.setup.nvim_comment").setup()
  require("conf.plugins.setup.autopairs").setup()
  require("conf.plugins.setup.symbols_outline").setup()
  require("conf.plugins.setup.nvim_tree").setup()
  require("conf.plugins.setup.hop").setup()
  require("conf.plugins.setup.scrollbar").setup()
  require("conf.plugins.setup.gitsigns").setup()
  require("conf.plugins.setup.harpoon").setup()
  require("conf.plugins.setup.tabline_framework").setup()
  require("conf.plugins.setup.which_key").setup()
  require("conf.plugins.setup.lsp_lines").setup()
  require("conf.plugins.setup.nvim_dap").setup()
  require("conf.plugins.setup.neotest").setup()
  require("conf.plugins.setup.git_conflict").setup()

  -- require("go").setup()
  require("gopher").setup({})
  -- require("structrue-go").setup()
end

return M
