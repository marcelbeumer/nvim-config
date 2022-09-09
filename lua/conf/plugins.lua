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
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
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

local setup_persistence = function()
  local path = vim.fn.stdpath("data") .. "/sessions/"
  local dir = vim.fn.expand(path, false, nil)
  local persistence = require("persistence")
  persistence.setup({ dir = dir })
  vim.api.nvim_create_user_command("LoadSession", persistence.load, {})
  vim.api.nvim_create_user_command("SaveSession", persistence.save, {})
  vim.api.nvim_create_user_command("StopSession", persistence.stop, {})
end

local setup_fzf_lua = function()
  local opts = { noremap = true, silent = true }
  local fzf = require("fzf-lua")

  fzf.setup({ winopts = { preview = { layout = "vertical" } } })

  local args_small = { previewer = false, winopts = { height = 0.20, width = 0.80 } }
  vim.keymap.set("n", "<leader>ff", function()
    fzf.files(args_small)
  end, opts)

  vim.keymap.set("n", "<leader>fb", function()
    fzf.buffers(args_small)
  end, opts)

  vim.keymap.set("n", "<leader>ft", function()
    fzf.tabs(args_small)
  end, opts)

  vim.keymap.set("n", "<leader>fc", fzf.commands, opts)
  vim.keymap.set("n", "<leader>fgp", fzf.live_grep_native, opts)
  vim.keymap.set("n", "<leader>fgb", fzf.grep_curbuf, opts)

  vim.keymap.set("n", "<leader>flq", fzf.diagnostics_document, {})
  vim.keymap.set("n", "<leader>flQ", fzf.diagnostics_workspace, {})
  vim.keymap.set("n", "<leader>flr", fzf.lsp_references, {})
  vim.keymap.set("n", "<leader>fls", fzf.lsp_document_symbols, {})
  vim.keymap.set("n", "<leader>flS", fzf.lsp_workspace_symbols, {})
  vim.keymap.set("n", "<leader>fli", fzf.lsp_implementations, {})
  vim.keymap.set("n", "<leader>fld", fzf.lsp_definitions, {})
  vim.keymap.set("n", "<leader>flD", fzf.lsp_declarations, {})
  vim.keymap.set("n", "<leader>flt", fzf.lsp_typedefs, {})
end

local setup_tokyonight = function()
  require("tokyonight").setup({
    style = "night",
    styles = {
      comments = "NONE",
      keywords = "NONE",
    },
  })
end

local setup_treesitter = function()
  local env = require("conf.env")

  -- Add gotmpl support. Requires scm file(s) in <repo>/queries/gotmpl.
  -- Not using the language injection because yaml and gotmpl don't play well
  -- together when mixed (probably bugs in parser). Instead, we implement
  -- automatic filetype switching for yaml.
  require("nvim-treesitter.parsers").get_parser_configs().gotmpl = {
    filetype = "gotmpl",
    used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl" },
    install_info = {
      url = "https://github.com/ngalaiko/tree-sitter-go-template",
      files = { "src/parser.c" },
    },
  }

  -- Terraform
  vim.cmd([[au BufNewFile,BufRead *.tf set ft=terraform ]])
  vim.cmd([[au BufNewFile,BufRead *.hcl,*.terraformrc,terraform.rc set ft=hcl ]])
  vim.cmd([[au BufNewFile,BufRead *.tfstate,*.tfstate.backup set ft=json ]])

  -- Treat .tpl and tmpl as gotmpl
  vim.cmd([[au BufNewFile,BufRead *.tpl set ft=gotmpl ]])
  vim.cmd([[au BufNewFile,BufRead *.tmpl set ft=gotmpl ]])

  if env.NVIM_GOTMPL_YAML == "on" then
    -- Treat .y(a)ml as gotmpl when buffer has template tags. Updates on save.
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWritePre" }, {
      pattern = { "*.yaml", "*.yml" },
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, line in ipairs(lines) do
          if line:match("{{.+}}") then
            vim.bo.ft = "gotmpl"
            return
          end
        end
        vim.bo.ft = "yaml"
      end,
    })
  end

  -- Set up treesitter itself.
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    -- phpdoc gave errors on darwin-arm64.
    ignore_install = { "phpdoc" },
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })

  -- Workaround for slow go files:
  -- https://github.com/NvChad/NvChad/issues/1415#issuecomment-1203723816
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3263
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3187
  require("vim.treesitter.query").set_query("go", "injections", "(comment) @comment")
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

local setup_symbols_outline = function()
  vim.keymap.set("n", "<leader>/", "<cmd>SymbolsOutline<cr>", {})
  vim.g.symbols_outline = {
    highlight_hovered_item = false,
    show_guides = true,
    auto_preview = false,
    position = "left",
    keymaps = {
      close = { "q" },
      hover_symbol = "K",
      toggle_preview = "P",
    },
  }
end

local setup_nvim_tree = function()
  require("nvim-tree").setup({
    view = {
      mappings = {
        list = {
          { key = "[d", action = "prev_diag_item" },
          { key = "]d", action = "next_diag_item" },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = { error = "●", warning = "●", hint = "●", info = "●" },
    },
    renderer = {
      icons = {
        show = {
          folder = false,
          file = false,
        },
      },
    },
  })

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>;", ":NvimTreeToggle<cr>", opts)
  vim.keymap.set("n", "<leader>'", ":NvimTreeFindFile<cr>", opts)
end

local setup_hop = function()
  require("hop").setup()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>w", ":HopWordAC<cr>", opts)
  vim.keymap.set("n", "<leader>W", ":HopWordBC<cr>", opts)
  vim.keymap.set("n", "<leader>o", ":HopWordMW<cr>", opts)
end

local setup_scrollbar = function()
  require("scrollbar").setup()
end

local setup_gitsigns = function()
  require("gitsigns").setup({ signcolumn = false })
end

-- make_lsp_capabilities updates the default LSP capabilities options
-- with features that our autocomplete plugin supports.
M.make_lsp_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").update_capabilities(capabilities)
end

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
  use("kyazdani42/nvim-tree.lua")
  -- Simple session management.
  use("folke/persistence.nvim")
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
  use("folke/tokyonight.nvim")
  -- Icons.
  use("kyazdani42/nvim-web-devicons")
  -- Code navigation.
  use("simrat39/symbols-outline.nvim")
  -- Motion.
  use("phaazon/hop.nvim")
  -- UI.
  use("petertriho/nvim-scrollbar")
end

M.setup = function()
  M.register()

  setup_tokyonight()
  vim.cmd([[colorscheme tokyonight]])

  setup_cmp()
  setup_treesitter()
  setup_persistence()
  setup_fzf_lua()
  setup_nvim_comment()
  setup_autopairs()
  setup_symbols_outline()
  setup_nvim_tree()
  -- require("go").setup()
  setup_hop()
  setup_scrollbar()
  setup_gitsigns()
end

return M
