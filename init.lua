-- Env vars.

-- NVIM_DARK=1 (default 1) for dark background.
local dark = vim.env.NVIM_DARK ~= "0"

-- NVIM_AUTOCOMPLETE=1 (default 0) to setup autocompletion plugin.
-- Rarely used, generally prefer manual omnicomplete with <C-x><C-o>.
local autocomplete = vim.env.NVIM_AUTOCOMPLETE == "1"

-- NVIM_LESS_COLORS=1 (default 1) to remove colors from syntax highlighting.
-- Especially with Go code is pretty as it is.
local less_colors = vim.env.NVIM_LESS_COLORS ~= "0"

-- NVIM_GOPLS_LOCAL=<prefixes> (default "") to group packages together when
-- tidying imports with the gopls language server.
local gopls_local = vim.env.NVIM_GOPLS_LOCAL or ""

-- Builtins.

vim.o.termguicolors = true -- required for macOS alacritty -> lima setup
vim.o.clipboard = "unnamedplus" -- always system clipboard
vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes" -- space for LSP signs
vim.o.breakindent = true -- continue break on same col
vim.o.linebreak = true
vim.o.breakat = " ^I!@-+;:,./?" -- removed "*" from default
vim.o.textwidth = 79
vim.o.completeopt = "menu,menuone,noinsert,fuzzy" -- nicest <c-x><c-o>
vim.o.foldlevel = 99 -- no default collapse with treesitter
vim.o.winborder = "rounded"
vim.o.cursorline = true -- highlight the text line of the cursor

-- formatoptions is a sequence of letters which describes how automatic
-- formatting is to be done. Default value tcqj.
-- t: auto-wrap using textwidth; not nice with Go code which allows >79
-- c: same for comments
-- q: allow formatting of comments with gq
-- j: join lines where makes sense
-- o: automatically insert comment leader after hitting o/O
-- r: automatically insert comment leader after hitting enter
vim.o.formatoptions = "cqjro"

if not dark then
  vim.o.background = "light"
end

vim.keymap.set("n", "]t", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "[t", ":tabprev<CR>", { desc = "Previous tab" })

-- Colorcolumn is not pretty enough to see at all times.
vim.keymap.set("n", "<leader>c", function()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = "80"
  else
    vim.o.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn (ruler)" })

vim.keymap.set("n", "<leader>z", function()
  vim.o.spell = not vim.o.spell
end, { desc = "Toggle spell checker" })

-- Inspired by JetBrains editors, show linebreaks with an arrow indicator.
-- But only in insert mode, otherwise add an empty char.
vim.cmd([[
  set showbreak=\ 
  augroup ShowbreakToggle
    autocmd!
    autocmd InsertEnter * set showbreak=↪
    autocmd InsertLeave * set showbreak=\ 
  augroup END
]])

vim.cmd([[command W w]]) -- happens

vim.diagnostic.config({
  severity_sort = true, -- see errors first
  signs = { -- icons
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- Send diagnostics to quickfix.
vim.keymap.set("n", "<leader>qd", vim.diagnostic.setqflist, { desc = "Set diagnostics to quickfix" })

-- Easier access to diagnostic than with default <c-w>d binding.
vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })

-- For pretty printing lua objects (`:lua dump(vim.fn)`).
_G.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

_G.yank = function(v)
  vim.fn.setreg("+", v)
  print("Yanked: " .. v)
end

-- Yank datetime like "2025-12-31 13:30:23".
vim.keymap.set("n", "<leader>yt", function()
  yank(os.date("%Y-%m-%d %H:%M:%S"))
end)

-- Yank filepath:linenumber.
vim.keymap.set("n", "<leader>yy", function()
  yank(vim.fn.expand("%h") .. ":" .. vim.fn.line("."))
end)

-- Plugins.

vim.pack.add({
  "https://github.com/marcelbeumer/less-colors.nvim", -- hide syntax highlighting
  "https://github.com/stevearc/oil.nvim", -- better netrw
  "https://github.com/kevinhwang91/nvim-bqf", -- better quickfix
  "https://github.com/marcelbeumer/qfctl.nvim", -- quickfix control
  "https://github.com/marcelbeumer/boring-statusline.nvim", -- better statusline
  "https://github.com/nvim-treesitter/nvim-treesitter", -- treesitter
  "https://github.com/neovim/nvim-lspconfig", -- lsp
  "https://github.com/stevearc/conform.nvim", -- formatters
  "https://github.com/nvim-mini/mini.pairs", -- auto pairs
  "https://github.com/nvim-mini/mini.surround", -- surround operations
  "https://github.com/nvim-mini/mini.ai", -- more textobjects
  "https://github.com/folke/persistence.nvim", -- restore session
  "https://github.com/nvim-mini/mini.pick", -- quick files/grep
  "https://github.com/kdheepak/lazygit.nvim", -- git
  "https://github.com/tpope/vim-fugitive", -- git
  "https://github.com/mason-org/mason.nvim", -- install/update external tools
  "https://github.com/marcelbeumer/next-lsp-reference.nvim", -- lsp util
  "https://github.com/marcelbeumer/less-indented-line.nvim", -- jump util
  { src = "https://github.com/Saghen/blink.cmp", version = "v1.8.0" }, -- autocomplete
})

require("less-colors").setup({
  enabled = less_colors,
})

local treesitter_langs = {
  "bash",
  "c",
  "diff",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "python",
  "typescript",
  "xml",
  "yaml",
  "zig",
}

require("nvim-treesitter").install(treesitter_langs)

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_langs,
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
  end,
})

require("mini.pairs").setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.b.minipairs_disable = true
  end,
})

require("mini.surround").setup()
require("mini.ai").setup()
require("mason").setup()
require("boring-statusline").setup()
require("persistence").setup()

vim.keymap.set("n", "<leader>ss", function()
  require("persistence").load()
end)
vim.keymap.set("n", "<leader>sS", function()
  require("persistence").select()
end)
vim.keymap.set("n", "<leader>sl", function()
  require("persistence").load({ last = true })
end)
vim.keymap.set("n", "<leader>sd", function()
  require("persistence").stop()
end)

vim.keymap.set("n", "gp", function()
  require("less-indented-line").jump("%S")
end, {})
vim.keymap.set("n", "gP", function()
  require("less-indented-line").jump("%s?func%s")
end, {})

require("oil").setup({
  keymaps = {
    ["gy"] = { "actions.yank_entry", mode = "n" },
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

require("bqf").setup({
  preview = {
    auto_preview = false,
  },
})

require("qfctl").setup({})

local pick = require("mini.pick")
pick.setup({ source = { show = pick.default_show } })

vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "Pick files" })
vim.keymap.set("n", "<leader>b", "<cmd>Pick buffers<cr>", { desc = "Pick buffers" })
vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "Grep live (rg)" })

require("conform").setup({
  formatters_by_ft = {
    go = { "gofumpt" },
    lua = { "stylua" },
  },
  format_on_save = function(bufnr)
    if not vim.g.disable_autoformat then
      return { timeout_ms = 500, lsp_format = "fallback" }
    end
  end,
})

vim.api.nvim_create_user_command("AutoformatToggle", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  if vim.g.disable_autoformat then
    vim.notify("Disabled auto formatting")
  else
    vim.notify("Enabled auto formatting")
  end
end, {})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local lsp_capabilities

if autocomplete then
  require("blink.cmp").setup({
    keymap = {
      preset = "enter",
    },
  })
  lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
else
  lsp_capabilities = vim.lsp.protocol.make_client_capabilities() -- defaults
end

-- LSP.

vim.lsp.config("gopls", {
  init_options = {
    buildFlags = { "-tags=integration" },
    hints = {
      assignVariableTypes = true,
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      constantValues = true,
      functionTypeParameters = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
  },
  capabilities = lsp_capabilities,
  settings = {
    gopls = {
      ["local"] = gopls_local,
    },
  },
})

vim.lsp.enable("gopls")
vim.lsp.enable("terraformls")

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    local opts = { buffer = args.buf }
    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "grh", vim.lsp.buf.document_highlight, opts)
    vim.keymap.set("n", "grc", vim.lsp.buf.clear_references, opts)
    vim.keymap.set("n", "<space>I", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end)
    vim.keymap.set("n", "<space>H", function()
      local enabled = not vim.lsp.inlay_hint.is_enabled()
      vim.lsp.inlay_hint.enable(enabled)
    end, opts)
    vim.keymap.set("n", "]r", require("next-lsp-reference").forward, opts)
    vim.keymap.set("n", "[r", require("next-lsp-reference").backward, opts)
  end,
})
