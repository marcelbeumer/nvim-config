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
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = require("conf.plugins.setup.treesitter").setup,
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
    { "olimorris/persisted.nvim", config = require("conf.plugins.setup.persisted").setup },

    -- Project switching.
    { "ahmedkhalf/project.nvim", config = require("conf.plugins.setup.project_nvim").setup },

    -- Lua dev setup
    { "folke/neodev.nvim", dependencies = { "neovim/nvim-lspconfig" } },

    -- Autocompletion and plugins.
    {
      "hrsh7th/nvim-cmp",
      config = require("conf.plugins.setup.cmp").setup,
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
      },
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
    { "terrortylor/nvim-comment", config = require("conf.plugins.setup.nvim_comment").setup },

    -- Automagically insert closing tags etc.
    { "windwp/nvim-autopairs", config = true },

    -- Colorschemes.
    { "folke/tokyonight.nvim", config = require("conf.plugins.setup.tokyonight").setup },
    { "catppuccin/nvim", name = "catppuccin" },
    { "sainnhe/everforest" },
    { "rebelot/kanagawa.nvim" },
    { "JoosepAlviste/palenightfall.nvim" },

    -- Icons.
    "kyazdani42/nvim-web-devicons",

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
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "haydenmeade/neotest-jest",
        "nvim-neotest/neotest-go",
      },
      config = require("conf.plugins.setup.neotest").setup,
    },

    -- UI.
    { "rafcamlet/tabline-framework.nvim", config = require("conf.plugins.setup.tabline_framework").setup },
    { "petertriho/nvim-scrollbar", config = require("conf.plugins.setup.scrollbar").setup },
    { "marcelbeumer/harpoon", branch = "fix/no-absolute-path", config = require("conf.plugins.setup.harpoon").setup },
    { "folke/which-key.nvim", config = require("conf.plugins.setup.which_key").setup },

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
    "github/copilot.vim",
  })

  vim.cmd.colorscheme("tokyonight")
end

return M
