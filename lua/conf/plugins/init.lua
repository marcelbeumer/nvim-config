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
    {
      "williamboman/mason.nvim",
      config = require("conf.plugins.setup.mason").setup,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = require("conf.plugins.setup.treesitter").setup,
    },

    {
      "nvim-treesitter/nvim-treesitter-context",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = require("conf.plugins.setup.treesitter-context").setup,
    },

    -- Indent guide lines.
    {
      "lukas-reineke/indent-blankline.nvim",
      config = require("conf.plugins.setup.indent_blankline").setup,
    },

    -- Icons.
    "nvim-tree/nvim-web-devicons",

    -- Modern folding.
    {
      "kevinhwang91/nvim-ufo",
      dependencies = { "kevinhwang91/promise-async" },
      config = require("conf.plugins.setup.ufo").setup,
    },

    -- LSP inlay hint support
    { "lvimuser/lsp-inlayhints.nvim", config = require("conf.plugins.setup.lsp_inlayhints").setup },

    -- TypeScript: support different comment styles depending on context.
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- TypeScript: extra LSP features.
    "jose-elias-alvarez/typescript.nvim",
    -- TypeScript: vtsls LSP plugin.
    { "yioneko/nvim-vtsls" },

    -- File explorer.
    { "kyazdani42/nvim-tree.lua", config = require("conf.plugins.setup.nvim_tree").setup },

    -- Simple session management.
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      init = require("conf.plugins.setup.persistence").init,
      config = require("conf.plugins.setup.persistence").config,
    },

    -- Project switching.
    { "ahmedkhalf/project.nvim", config = require("conf.plugins.setup.project_nvim").setup },

    -- Lua dev setup
    { "folke/neodev.nvim", dependencies = { "neovim/nvim-lspconfig" } },

    -- Better LSP signature help.
    { "ray-x/lsp_signature.nvim" },

    -- Autocompletion and plugins.
    {
      "hrsh7th/nvim-cmp",
      config = require("conf.plugins.setup.cmp").setup,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
      },
    },

    {
      "L3MON4D3/LuaSnip",
      config = require("conf.plugins.setup.luasnip").setup,
    },

    -- General purpose LSP server, mostly for linting and formatting.
    -- "jose-elias-alvarez/null-ls.nvim",
    { "marcelbeumer/null-ls.nvim", branch = "fix-golangci-lint" },

    -- Git.
    { "tpope/vim-fugitive" },
    { "kdheepak/lazygit.nvim", config = require("conf.plugins.setup.lazygit").setup },
    { "sindrets/diffview.nvim" },
    { "lewis6991/gitsigns.nvim", config = require("conf.plugins.setup.gitsigns").setup },
    { "akinsho/git-conflict.nvim", config = true },

    -- Quick file/buffer/lsp/etc pickers.
    { "ibhagwan/fzf-lua", config = require("conf.plugins.setup.fzf_lua").setup },

    -- Go specific features.
    { "olexsmir/gopher.nvim" },

    -- Commenting plugin.
    { "echasnovski/mini.comment", config = require("conf.plugins.setup.mini_comment").setup },

    -- Automagically insert closing tags etc.
    { "echasnovski/mini.pairs", config = require("conf.plugins.setup.mini_pairs").setup },

    -- Colorschemes.
    { "folke/tokyonight.nvim", config = require("conf.plugins.setup.tokyonight").setup },
    { "catppuccin/nvim", name = "catppuccin" },
    { "sainnhe/everforest" },
    { "rebelot/kanagawa.nvim" },
    { "JoosepAlviste/palenightfall.nvim" },
    { "AlexvZyl/nordic.nvim" },
    { "felipeagc/fleet-theme-nvim", dependencies = { "rktjmp/lush.nvim" } },

    -- Code navigation.
    { "simrat39/symbols-outline.nvim", config = require("conf.plugins.setup.symbols_outline").setup },

    -- Motion.
    { "phaazon/hop.nvim", config = require("conf.plugins.setup.hop").setup },

    -- Debugging.
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "rcarriga/nvim-dap-ui",
        "mxsdev/nvim-dap-vscode-js",
        "theHamsta/nvim-dap-virtual-text",
      },
      config = function()
        require("conf.plugins.setup.nvim_dap").setup()
      end,
    },

    -- Tests.
    {
      "marcelbeumer/neotest",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-go",
      },
      config = require("conf.plugins.setup.neotest").setup,
    },

    -- UI.
    { "rafcamlet/tabline-framework.nvim", config = require("conf.plugins.setup.tabline_framework").setup },
    { "marcelbeumer/harpoon", branch = "fix/no-absolute-path", config = require("conf.plugins.setup.harpoon").setup },
    { "folke/which-key.nvim", config = require("conf.plugins.setup.which_key").setup },
    {
      "folke/trouble.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = require("conf.plugins.setup.trouble").setup,
    },
    {
      "stevearc/aerial.nvim",
      opts = {},
      -- Optional dependencies
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = require("conf.plugins.setup.aerial").setup,
    },

    -- Search and replace
    {
      "nvim-pack/nvim-spectre",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = require("conf.plugins.setup.nvim_spectre").setup,
    },

    -- Buffer management.
    "kazhala/close-buffers.nvim",

    -- Improved Yank/put.
    { "gbprod/yanky.nvim", config = require("conf.plugins.setup.yanky").setup },

    -- Misc.
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = require("conf.plugins.setup.copilot").setup,
    },
  })

  vim.cmd.colorscheme("tokyonight")
end

return M
