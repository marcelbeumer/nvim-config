local M = {}

M.setup = function()
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
    -- ======================================
    -- General.
    -- ======================================

    "nvim-tree/nvim-web-devicons",

    -- ======================================
    -- External tooling.
    -- ======================================

    {
      "williamboman/mason.nvim",
      command = "Mason",
      config = require("conf0.plugins.setup.mason").setup,
    },

    -- ======================================
    -- Treesitter.
    -- ======================================

    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = require("conf0.plugins.setup.treesitter").setup,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = require("conf0.plugins.setup.treesitter-context").setup,
    },
    -- TypeScript: support different comment styles depending on context.
    { "JoosepAlviste/nvim-ts-context-commentstring" },

    -- ======================================
    -- UI and editing enhancements.
    -- ======================================

    { "kyazdani42/nvim-tree.lua", config = require("conf0.plugins.setup.nvim_tree").setup },
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      init = require("conf0.plugins.setup.persistence").init,
      config = require("conf0.plugins.setup.persistence").config,
    },
    { "simrat39/symbols-outline.nvim", config = require("conf0.plugins.setup.symbols_outline").setup },
    -- Quick file/buffer/lsp/etc pickers.
    { "ibhagwan/fzf-lua", config = require("conf0.plugins.setup.fzf_lua").setup },
    {
      "rafcamlet/tabline-framework.nvim",
      config = require("conf0.plugins.setup.tabline_framework").setup,
    },
    {
      "ThePrimeagen/harpoon",
      config = require("conf0.plugins.setup.harpoon").setup,
    },
    {
      "folke/which-key.nvim",
      config = require("conf0.plugins.setup.which_key").setup,
    },
    {
      "folke/trouble.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = require("conf0.plugins.setup.trouble").setup,
    },
    {
      "stevearc/aerial.nvim",
      opts = {},
      event = "LspAttach",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = require("conf0.plugins.setup.aerial").setup,
    },
    -- Search and replace
    {
      "nvim-pack/nvim-spectre",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = require("conf0.plugins.setup.nvim_spectre").setup,
    },
    -- Buffer management.
    "kazhala/close-buffers.nvim",
    -- Improved Yank/put.
    { "gbprod/yanky.nvim", config = require("conf0.plugins.setup.yanky").setup },
    {
      "lukas-reineke/indent-blankline.nvim",
      config = require("conf0.plugins.setup.indent_blankline").setup,
    },
    {
      "kevinhwang91/nvim-ufo",
      dependencies = { "kevinhwang91/promise-async" },
      config = require("conf0.plugins.setup.ufo").setup,
    },
    { "echasnovski/mini.comment", config = require("conf0.plugins.setup.mini_comment").setup },
    { "echasnovski/mini.pairs", config = require("conf0.plugins.setup.mini_pairs").setup },
    {
      "kylechui/nvim-surround",
      event = "VeryLazy",
      config = require("conf0.plugins.setup.nvim_surround").setup,
    },
    { "LeonHeidelbach/trailblazer.nvim", config = require("conf0.plugins.setup.trailblazer").setup },
    {
      "hrsh7th/nvim-cmp",
      version = false,
      event = "BufEnter",
      config = function()
        require("conf0.plugins.setup.luasnip").setup()
        require("conf0.plugins.setup.cmp").setup()
      end,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
      },
    },
    -- Git.
    { "tpope/vim-fugitive" },
    { "kdheepak/lazygit.nvim", config = require("conf0.plugins.setup.lazygit").setup },
    { "sindrets/diffview.nvim" },
    { "lewis6991/gitsigns.nvim", config = require("conf0.plugins.setup.gitsigns").setup },
    { "akinsho/git-conflict.nvim", config = true },
    {
      "marcelbeumer/neotest",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-go",
      },
      config = require("conf0.plugins.setup.neotest").setup,
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = require("conf0.plugins.setup.copilot").setup,
    },
    {
      "nvim-lualine/lualine.nvim",
      config = require("conf0.plugins.setup.lualine").setup,
    },

    -- ======================================
    -- Language support.
    -- ======================================
    { "folke/neodev.nvim", dependencies = { "neovim/nvim-lspconfig" } },
    { "olexsmir/gopher.nvim" },

    -- ======================================
    -- LSP.
    -- ======================================

    {
      "lvimuser/lsp-inlayhints.nvim",
      config = require("conf0.plugins.setup.lsp_inlayhints").setup,
    },
    { "jose-elias-alvarez/typescript.nvim" },
    { "yioneko/nvim-vtsls" },
    { "ray-x/lsp_signature.nvim" },
    { "marcelbeumer/null-ls.nvim", branch = "fix-golangci-lint" },

    -- ======================================
    -- DAP.
    -- ======================================

    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "rcarriga/nvim-dap-ui",
        "mxsdev/nvim-dap-vscode-js",
        -- "theHamsta/nvim-dap-virtual-text",
      },
      config = function()
        require("conf0.plugins.setup.nvim_dap").setup()
      end,
    },

    -- ======================================
    -- Colorschemes.
    -- ======================================

    { "folke/tokyonight.nvim", config = require("conf0.plugins.setup.tokyonight").setup },
    { "catppuccin/nvim", name = "catppuccin" },
    { "sainnhe/everforest" },
    { "rebelot/kanagawa.nvim" },
    { "JoosepAlviste/palenightfall.nvim" },
    { "AlexvZyl/nordic.nvim" },
    { "felipeagc/fleet-theme-nvim", dependencies = { "rktjmp/lush.nvim" } },
  }, {
    performance = {
      cache = {
        -- Caching slows things down when using a corporate laptop.
        enabled = false,
      },
    },
  })

  vim.cmd.colorscheme("tokyonight")
end

return M
