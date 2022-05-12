local function nmap(lhs, rhs)
  vim.api.nvim_set_keymap("n", lhs, rhs, { silent = true, noremap = true })
end

local M = {}

M.setup = function()
  -- Use 2 spaces tab as default
  vim.o.expandtab = true
  vim.o.shiftwidth = 2
  vim.o.softtabstop = 2
  vim.o.tabstop = 2
  --Set highlight on search
  vim.o.hlsearch = false
  -- Line numbers on
  vim.o.number = true
  --Enable mouse mode in all modes
  vim.o.mouse = "a"
  --Enable break indent
  vim.o.breakindent = true
  --Save undo history
  vim.o.undofile = true
  --Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true
  --Decrease update time
  vim.o.updatetime = 250
  -- Space for LSP signs etc
  vim.o.signcolumn = "yes"
  vim.o.termguicolors = true
  -- Copy paste from and to nvim
  vim.o.clipboard = "unnamed"
  -- Set completeopt to have a better completion experience
  vim.o.completeopt = "menuone,noselect"

  -- Commands
  vim.cmd([[command W w]])
  vim.cmd([[command FilePath let @*=expand("%")]])
  vim.cmd([[command FilePathAbs let @*=expand("%:p")]])
  vim.cmd([[command FilePathHead let @*=expand("%:h")]])
  vim.cmd([[command FilePathTail let @*=expand("%:t")]])
  vim.cmd([[command Todo e ~/Notes/content/todo.md]])
  vim.cmd([[command Scratch e ~/Notes/content/scratch.md]])
  vim.cmd([[command Inbox e ~/Notes/content/inbox.md]])
  -- vim.cmd([[command Garc !git ar && git c -am "..."]])
  vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=200, on_visual=true}]])

  -- Bindings
  nmap("]q", ":cnext")
  nmap("]q", ":cnext<CR>")
  nmap("[q", ":cprev<CR>")
  nmap("]Q", ":lnext<CR>")
  nmap("[Q", ":lprev<CR>")
  nmap("]t", ":tabnext<CR>")
  nmap("[t", ":tabprev<CR>")
  nmap("<C-L>", ":tabnext<CR>")
  nmap("<C-H>", ":tabprev<CR>")
  nmap("<C-s>", ":w<CR>")
  nmap("<C-w>N", ":vnew<CR>")
  nmap("<leader>s", ":w<CR>")
  nmap("<leader>tn", ":tabnew<CR>")
  nmap("<leader>tb", ":tab sb %<CR>")
  nmap("<leader>tc", ":tabclose<CR>")
  nmap("<leader>bd", ":bdel<CR>")
end

return M
