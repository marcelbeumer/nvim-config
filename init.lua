-- TODO:
-- * LSP prev/next reference?
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

-- Statusline.

local diagnostics_status_cached = ""

local diagnostics_status = function()
  if diagnostics_status_cached ~= "" then
    return diagnostics_status_cached
  end

  local diagnostics = vim.diagnostic.get(0, {})
  local severity = vim.diagnostic.severity
  local diag_icon = {
    [severity.ERROR] = "",
    [severity.WARN] = "",
    [severity.HINT] = "󰌶",
    [severity.INFO] = "",
  }
  local totals = {
    [severity.ERROR] = 0,
    [severity.WARN] = 0,
    [severity.HINT] = 0,
    [severity.INFO] = 0,
  }
  for _, d in ipairs(diagnostics) do
    totals[d.severity] = totals[d.severity] + 1
  end

  local status = ""
  for level, total in pairs(totals) do
    if total > 0 then
      status = status .. string.format("%s %d ", diag_icon[level], total)
    end
  end

  diagnostics_status_cached = status
  return status
end

_G.statusline = function()
  local file_path = "%f"
  local line_col = "%8(%l,%c%)"
  local position = "%5P"

  return string.format("%s %%=%s %s %s", file_path, diagnostics_status(), line_col, position)
end

local function debounce(callback, delay)
  local timer = nil
  return function()
    if timer then
      return
    end
    timer = vim.defer_fn(function()
      timer = nil
      callback()
    end, delay)
  end
end

vim.o.statusline = "%!v:lua.statusline()"

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = debounce(function()
    diagnostics_status_cached = ""
    vim.cmd.redrawstatus()
  end, 200),
  group = vim.api.nvim_create_augroup("UpdateStatusline", { clear = true }),
})

-- Jump to less indented lines.

local function jump_to_less_indented_line(line_match)
  local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
  local current_indent = vim.fn.indent(current_line_num)

  for line_num = current_line_num - 1, 1, -1 do
    local line_content = tostring(vim.fn.getline(line_num))
    local indent = vim.fn.indent(line_num)
    if line_content:match(line_match) and indent < current_indent then
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_cursor(0, { line_num, 0 })
      if indent > 0 then
        vim.cmd("normal! w")
      end
      vim.cmd("normal! m'")
      break
    end
  end
end

vim.keymap.set("n", "gp", function()
  jump_to_less_indented_line("%S")
end, {})
vim.keymap.set("n", "gP", function()
  jump_to_less_indented_line("%s?func%s")
end, {})

-- Plugins.

vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/nvim-mini/mini.pick",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/folke/persistence.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/mason-org/mason.nvim",
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

vim.keymap.set("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "Lazgit" })

require("oil").setup()

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
