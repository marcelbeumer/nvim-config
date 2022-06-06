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
    preselect = types.cmp.PreselectMode.None,
    sorting = {
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

  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
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
  vim.cmd([[colorscheme tokyonight]])
end

local setup_treesitter = function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
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
      require("ts_context_commentstring.internal").update_commentstring()
    end,
  })
end

local setup_autopairs = function()
  require("nvim-autopairs").setup({})
end

M.register = function()
  local packer = require("packer")
  local use = packer.use
  packer.init()
  packer.reset()

  use("wbthomason/packer.nvim")
  use("editorconfig/editorconfig-vim")
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("JoosepAlviste/nvim-ts-context-commentstring")
  use("nvim-lua/plenary.nvim")
  use("preservim/nerdtree")
  use("folke/persistence.nvim")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use("saadparwaiz1/cmp_luasnip")
  use("hrsh7th/nvim-cmp")
  use("L3MON4D3/LuaSnip")
  use("jose-elias-alvarez/null-ls.nvim")
  use("jose-elias-alvarez/nvim-lsp-ts-utils")
  use("kdheepak/lazygit.nvim")
  use("neovim/nvim-lspconfig")
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-fzy-native.nvim")
  use("ray-x/go.nvim")
  use("folke/tokyonight.nvim")
  use("folke/lua-dev.nvim")
  use("terrortylor/nvim-comment")
  use("windwp/nvim-autopairs")
end

M.setup = function()
  M.register()
  setup_tokyonight()
  setup_cmp()
  setup_nerd()
  setup_treesitter()
  setup_persistence()
  setup_telescope()
  setup_nvim_comment()
  setup_autopairs()
  require("go").setup()
end

M.make_lsp_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").update_capabilities(capabilities)
end

return M
