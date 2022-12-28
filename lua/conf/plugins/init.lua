local M = {}

M.register = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.runtimepath:prepend(lazypath)

  require("lazy").setup({
    -- Common plugin dependency.
    "nvim-lua/plenary.nvim",
    -- Official LSP setup helper plugin, required by lua-dev.
    "neovim/nvim-lspconfig",
    -- LSP
    -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    -- Editor config support.
    "editorconfig/editorconfig-vim",
    -- Tresitter.
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    -- TypeScript: support different comment styles depending on context.
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- TypeScript: extra LSP features.
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    -- File explorer.
    "kyazdani42/nvim-tree.lua",
    -- Simple session management.
    "olimorris/persisted.nvim",
    -- Project switching.
    "ahmedkhalf/project.nvim",
    -- Lua dev setup
    "folke/neodev.nvim",
    -- Autocompletion and plugins.
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "saadparwaiz1/cmp_luasnip",
    -- Snippets (required by cmp autocomplete).
    "L3MON4D3/LuaSnip",
    -- General purpose LSP server, mostly for linting and formatting.
    -- "jose-elias-alvarez/null-ls.nvim",
    { "marcelbeumer/null-ls.nvim", branch = "fix-golangci-lint" },
    -- Git.
    "kdheepak/lazygit.nvim",
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",
    "lewis6991/gitsigns.nvim",
    "akinsho/git-conflict.nvim",
    -- Quick file/buffer/lsp/etc pickers.
    "ibhagwan/fzf-lua",
    -- Go specific features.
    -- "ray-x/guihua.lua",
    -- "ray-x/go.nvim", -- lots of features
    "olexsmir/gopher.nvim", -- minimal
    -- "crusj/structrue-go.nvim",
    -- Commenting plugin.
    "terrortylor/nvim-comment",
    -- Automagically insert closing tags etc.
    "windwp/nvim-autopairs",
    -- Colorscheme.
    "folke/tokyonight.nvim",
    { "catppuccin/nvim", name = "catppuccin" },
    -- Icons.
    "kyazdani42/nvim-web-devicons",
    -- Code navigation.
    "simrat39/symbols-outline.nvim",
    -- Motion.
    "phaazon/hop.nvim",
    -- Debugging.
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    "theHamsta/nvim-dap-virtual-text",
    -- Tests.
    "nvim-neotest/neotest",
    "haydenmeade/neotest-jest",
    -- UI.
    "rafcamlet/tabline-framework.nvim",
    "petertriho/nvim-scrollbar",
    { "marcelbeumer/harpoon", branch = "fix/no-absolute-path" },
    "folke/which-key.nvim",
    -- Buffer management.
    "kazhala/close-buffers.nvim",
    -- Improved Yank/put.
    "gbprod/yanky.nvim",
    -- Disabled but here for reference.
    -- "NvChad/nvim-colorizer.lua",
    -- Misc.
    "github/copilot.vim",
  })
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
  -- require("conf.plugins.setup.lsp_lines").setup()
  require("conf.plugins.setup.nvim_dap").setup()
  require("conf.plugins.setup.neotest").setup()
  require("conf.plugins.setup.git_conflict").setup()

  -- require("go").setup()
  require("gopher").setup({})
  -- require("structrue-go").setup()
end

return M
