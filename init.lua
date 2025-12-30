-- TODO:
-- * formatoption, formatexpr, gw, gq, ok like this? Can be simpler?

vim.o.clipboard = "unnamedplus"
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes" -- space for LSP signs
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.breakat = " ^I!@-+;:,./?" -- removed "*" from default
vim.o.textwidth = 79
vim.o.formatoptions = "croqj" -- use gw; gq will be set by lsp/conform
vim.o.completeopt = "menu,menuone,noinsert,fuzzy"
vim.o.foldlevel = 99 -- no default collapse with treesitter

vim.keymap.set("n", "]t", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "[t", ":tabprev<CR>", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>c", function()
  if vim.o.colorcolumn == "" then
    vim.o.colorcolumn = "80"
  else
    vim.o.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn (ruler)" })

vim.cmd([[
  set showbreak=\ 
  augroup ShowbreakToggle
    autocmd!
    autocmd InsertEnter * set showbreak=↪
    autocmd InsertLeave * set showbreak=\ 
  augroup END
]])

vim.cmd([[command W w]])

-- For pretty printing lua objects (`:lua dump(vim.fn)`)
_G.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

vim.cmd([[
  function! DateStrPretty() range
    return system('date "+%Y-%m-%d %H:%M:%S" | tr -d "\n"')
  endfunction

  function! DateStrFs() range
    return system('date "+%Y-%m-%d-%H%M-%S" | tr -d "\n"')
  endfunction
]])

vim.api.nvim_create_user_command("YankPath", function()
  local path = vim.fn.expand("%h")
  vim.fn.setreg("+", path)
  print("Yanked: " .. path)
end, {})

vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- Plugins.

vim.pack.add({
  "https://github.com/stevearc/oil.nvim", -- file browser
  "https://github.com/neovim/nvim-lspconfig", -- lsp
  "https://github.com/stevearc/conform.nvim", -- formatters
  "https://github.com/nvim-mini/mini.pick", -- files/grep
  "https://github.com/kevinhwang91/nvim-bqf", -- better quickfix
  "https://github.com/kdheepak/lazygit.nvim", -- git
  "https://github.com/tpope/vim-fugitive", -- git
  "https://github.com/folke/persistence.nvim", -- restore session
  "https://github.com/nvim-treesitter/nvim-treesitter", -- treesitter
  "https://github.com/mason-org/mason.nvim", -- install/update external tools
  "https://github.com/marcelbeumer/next-lsp-reference.nvim", -- lsp util
  "https://github.com/marcelbeumer/less-indented-line.nvim", -- jump util
  "https://github.com/marcelbeumer/boring-statusline.nvim", -- better statusline
})

local treesitter_langs = {
  "bash",
  "c",
  "diff",
  "go",
  "html",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "python",
  "typescript",
  "xml",
  "yaml",
  "zig",
}

require("mason").setup()

require("nvim-treesitter").install(treesitter_langs)

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_langs,
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
  end,
})

require("persistence").setup({})

require("boring-statusline").setup()

vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end)
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end)
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end)
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end)

vim.keymap.set("n", "gp", function()
  require("less-indented-line").jump("%S")
end, {})
vim.keymap.set("n", "gP", function()
  require("less-indented-line").jump("%s?func%s")
end, {})

vim.keymap.set("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "Lazgit" })

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

local pick = require("mini.pick")
pick.setup({ source = { show = pick.default_show } })

vim.keymap.set("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "Pick files" })
vim.keymap.set("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "Grep live (rg)" })

require("conform").setup({
  formatters_by_ft = {
    go = { "gofumpt" },
    lua = { "stylua" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
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
  settings = {
    gopls = {
      ["local"] = vim.env.NVIM_GOPLS_LOCAL or "",
    },
  },
})

vim.lsp.enable("gopls")

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
    vim.keymap.set("n", "]r", require("next-lsp-reference").next, opts)
    vim.keymap.set("n", "[r", require("next-lsp-reference").prev, opts)
  end,
})

-- Colors and colorscheme.

local function less_colors()
  local normal_fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg", "gui")
  vim.api.nvim_set_hl(0, "Comment", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "String", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Character", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Number", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Boolean", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Float", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Identifier", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Function", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Statement", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Type", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "Special", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "@spell", { fg = normal_fg })
end

vim.api.nvim_create_user_command("LessColors", less_colors, {})
less_colors()
