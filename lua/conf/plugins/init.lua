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
  use("nvim-telescope/telescope.nvim")
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
  --
  --
  --
  local get_filename_fn = function()
    local bufnr_name_cache = {}
    return function(bufnr)
      bufnr = vim.F.if_nil(bufnr, 0)
      local c = bufnr_name_cache[bufnr]
      if c then
        return c
      end

      local n = vim.api.nvim_buf_get_name(bufnr)
      bufnr_name_cache[bufnr] = n
      return n
    end
  end

  local utils = require("telescope.utils")
  local x = function(opts)
    opts = opts or {}
    local hidden = utils.is_path_hidden(opts)
    local make_display = function(entry)
      return string.format("%s:%d:%d:%s", utils.transform_path(opts, entry.filename), entry.lnum, entry.col, entry.text)
    end

    local get_filename = get_filename_fn()
    return function(entry)
      local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))

      return require("telescope.make_entry").set_default_entry_mt({
        value = entry,
        ordinal = (not hidden and filename or "") .. " " .. entry.text,
        display = make_display,
        bufnr = entry.bufnr,
        filename = filename,
        lnum = entry.lnum,
        col = entry.col,
        text = entry.text,
        start = entry.start,
        finish = entry.finish,
      }, opts)
    end
  end

  require("telescope").setup({
    defaults = {
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        vertical = {
          mirror = true,
          anchor = "N",
          prompt_position = "top",
          width = 0.8,
          height = 0.9,
        },
      },
    },
    pickers = {
      find_files = {
        disable_devicons = true,
        previewer = false,
        layout_config = {
          height = 20,
        },
      },
      live_grep = {
        disable_devicons = true,
      },
      lsp_references = {
        entry_maker = x({}),
        -- entry_maker = require('telescope.make_entry').gen_from_vimgrep({}),
        -- path_display = {
        -- },
      },
    },
  })
end

return M
