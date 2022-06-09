local M = {}

local setup_cmp = function()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local luasnip = require("luasnip")

  vim.o.completeopt = "menu,menuone,noselect"
  vim.o.pumheight = 10
  cmp.setup.global({
    experimental = { ghost_text = true },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = {
        i = cmp.mapping.confirm({ select = true }),
      },
    }),
  })

  cmp.setup.filetype({ "go" }, {
    -- gopls preselects items which I don't like.
    preselect = types.cmp.PreselectMode.None,
    sorting = {
      -- IMO these comparator settings work better with gopls.
      comparators = {
        cmp.config.compare.length,
        cmp.config.compare.locality,
        cmp.config.compare.sort_text,
      },
    },
  })
end

local setup_nerd = function()
  vim.cmd([[
    let NERDTreeShowHidden=1
    let NERDTreeWinSize=35
    nnoremap <silent><leader>; :NERDTreeToggle<CR>
    nnoremap <silent><leader>' :NERDTreeFind<CR>
  ]])
end

local setup_persistence = function()
  local path = vim.fn.stdpath("data") .. "/sessions/"
  local dir = vim.fn.expand(path, false, nil)
  local persistence = require("persistence")
  persistence.setup({ dir = dir })
  vim.api.nvim_create_user_command("LoadSession", persistence.load, {})
  vim.api.nvim_create_user_command("SaveSession", persistence.save, {})
  vim.api.nvim_create_user_command("StopSession", persistence.stop, {})
end

local setup_telescope = function()
  local builtin = require("telescope.builtin")

  require("telescope").load_extension("fzy_native")
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<C-q>"] = require("telescope.actions").send_to_qflist,
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>ff", function()
    local ok = pcall(require("telescope.builtin").git_files, {})
    if not ok then
      require("telescope.builtin").find_files({})
    end
  end, {})
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
  vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
  vim.keymap.set("n", "<leader>fd", function()
    builtin.find_files({ find_command = { "find", ".", "-type", "d" } })
  end, {})
  vim.keymap.set("n", "<leader>fx", builtin.builtin, {})
  vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, {})

  vim.keymap.set("n", "<leader>flq", builtin.diagnostics, {})
  vim.keymap.set("n", "<leader>flr", builtin.lsp_references, {})
  vim.keymap.set("n", "<leader>fli", function()
    builtin.lsp_implementations({ jump_type = "never" })
  end, {})
  vim.keymap.set("n", "<leader>fld", function()
    builtin.lsp_definitions({ jump_type = "never" })
  end, {})
  vim.keymap.set("n", "<leader>flt", function()
    builtin.lsp_type_definitions({ jump_type = "never" })
  end, {})
end

local setup_tokyonight = function()
  vim.g.tokyonight_style = "night"
  vim.g.tokyonight_italic_comments = false
  vim.g.tokyonight_italic_keywords = false
end

local setup_treesitter = function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    -- phpdoc gave errors on darwin-arm64.
    ignore_install = { "phpdoc" },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    highlight = { enable = true },
  })
end

local setup_nvim_comment = function()
  require("nvim_comment").setup({
    hook = function()
      require("ts_context_commentstring.internal").update_commentstring({})
    end,
  })
end

local setup_autopairs = function()
  require("nvim-autopairs").setup({})
end

-- register registers all plugins with packer. We are not using packer's APIs
-- to configure plugins or manage their dependencies because explicitly
-- calling a few setup functions and keeping deps implicit keeps the code
-- so much simpler. Also it will be easy to swap packer for something else.
M.register = function()
  local packer = require("packer")
  local use = packer.use
  packer.init()
  packer.reset()

  -- Packer updates itself.
  use("wbthomason/packer.nvim")
  -- Dependancy of many plugins.
  use("nvim-lua/plenary.nvim")
  -- Official LSP setup helper plugin.
  use("neovim/nvim-lspconfig")
  -- Editor config support.
  use("editorconfig/editorconfig-vim")
  -- Tresitter.
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  -- TypeScript: support different comment styles depending on context.
  use("JoosepAlviste/nvim-ts-context-commentstring")
  -- TypeScript: extra LSP features.
  use("jose-elias-alvarez/nvim-lsp-ts-utils")
  -- File explorer.
  use("preservim/nerdtree")
  -- Simple session management.
  use("folke/persistence.nvim")
  -- Autocompletion and plugins.
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use("saadparwaiz1/cmp_luasnip")
  -- Snippets (required by cmp autocomplete).
  use("L3MON4D3/LuaSnip")
  -- General purpose LSP server, mostly for linting and formatting.
  use("jose-elias-alvarez/null-ls.nvim")
  -- Lazygit integration.
  use("kdheepak/lazygit.nvim")
  -- Quick file/buffer/lsp/etc pickers.
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-fzy-native.nvim")
  -- Go specific features.
  use("ray-x/go.nvim")
  -- Commenting plugin.
  use("terrortylor/nvim-comment")
  -- Automagically insert closing tags etc.
  use("windwp/nvim-autopairs")
  -- Colorscheme.
  use("folke/tokyonight.nvim")
end

M.setup = function()
  M.register()

  setup_tokyonight()
  vim.cmd([[colorscheme tokyonight]])

  setup_cmp()
  setup_nerd()
  setup_treesitter()
  setup_persistence()
  setup_telescope()
  setup_nvim_comment()
  setup_autopairs()
  require("go").setup()
end

-- make_lsp_capabilities updates the default LSP capabilities options
-- with features that our autocomplete plugin supports.
M.make_lsp_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").update_capabilities(capabilities)
end

return M
