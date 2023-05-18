local M = {}

M.setup = function()
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { silent = true }

  -- Line numbers.
  vim.o.number = true
  vim.o.relativenumber = true
  --Enable mouse mode in all modes.
  vim.o.mouse = "a"
  --Enable break indent.
  vim.o.breakindent = true
  --Save undo history.
  vim.o.undofile = true
  --Case insensitive searching UNLESS /C or capital in search.
  vim.o.ignorecase = true
  vim.o.smartcase = true
  --Decrease update time.
  vim.o.updatetime = 250
  -- Space for LSP signs etc.
  vim.o.signcolumn = "yes"
  vim.o.termguicolors = true
  -- Copy paste from and to nvim.
  vim.o.clipboard = "unnamed"
  -- Keep some space when scrolling.
  vim.o.scrolloff = 5
  -- Show search result counter.
  vim.opt.shortmess:remove({ "-S" })
  -- Highlight current line
  vim.o.cursorline = true
  -- Enable line based differ
  vim.opt.diffopt:append({ "linematch:60" })
  -- Fold settings recommended by nvim-ufo.
  vim.o.foldcolumn = "0" -- '0' is not bad
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99

  -- Line wrapping.
  vim.o.linebreak = true
  vim.o.breakat = " ^I!@-+;:,./?" -- removed "*" from default
  vim.cmd([[
    set showbreak=\ 
    augroup ShowbreakToggle
      autocmd!
      autocmd InsertEnter * set showbreak=↪
      autocmd InsertLeave * set showbreak=\ 
    augroup END
  ]])

  -- Netrw settings.
  vim.api.nvim_set_var("netrw_banner", 0)
  vim.api.nvim_set_var("netrw_altv", 1)

  -- Too many typos but too stubborn to map to smth else.
  vim.cmd([[command W w]])

  bind_all("base.write", ":w<CR>", {}, key_opts)
  bind_all("base.toggle_line_numbers", ":set nu!<CR>", {}, key_opts)
  bind_all("base.open_bottom_panel", ":botright 20split<CR>", {}, key_opts)
  bind_all("base.open_new_vsplit", ":vnew<CR>", {}, key_opts)
  bind_all("base.win_fix_width", ":set wfw<CR>", {}, key_opts)
  bind_all("base.win_fix_height", ":set wfh<CR>", {}, key_opts)
  bind_all("base.quickfix_next", ":cnext<CR>", {}, key_opts)
  bind_all("base.quickfix_prev", ":cprev<CR>", {}, key_opts)
  bind_all("base.loclist_next", ":lnext<CR>", {}, key_opts)
  bind_all("base.loclist_prev", ":lprev<CR>", {}, key_opts)
  bind_all("base.tab_next", ":tabnext<CR>", {}, key_opts)
  bind_all("base.tab_prev", ":tabprev<CR>", {}, key_opts)
  bind_all("base.tab_add", ":tabnew<CR>", {}, key_opts)
  bind_all("base.tab_close", ":tabclose<CR>", {}, key_opts)
  bind_all("base.buf_next", ":bnext<CR>", {}, key_opts)
  bind_all("base.buf_prev", ":bprevious<CR>", {}, key_opts)

  -- https://vi.stackexchange.com/questions/21260/how-to-clear-neovim-terminal-buffer#21364
  vim.cmd([[
    nmap <c-w><c-l> :set scrollback=1 \| sleep 100m \| set scrollback=10000<cr>
    tmap <c-\><c-\> <c-\><c-n><c-w><c-l>i<c-l>
  ]])

  -- DateStr* commands used in insert mode (<ctrl>r=DateStr<variant>)
  -- for inserting current datetime.
  vim.cmd([[
    function! DateStrPretty() range
      return system('date "+%Y-%m-%d %H:%M:%S" | tr -d "\n"')
    endfunction

    function! DateStrFs() range
      return system('date "+%Y-%m-%d-%H%M-%S" | tr -d "\n"')
    endfunction
  ]])

  -- Tabline show/hide
  vim.api.nvim_create_user_command("TablineShow", function()
    vim.o.showtabline = 2
  end, {})
  vim.api.nvim_create_user_command("TablineHide", function()
    vim.o.showtabline = 0
  end, {})

  -- Terraform
  vim.cmd([[au BufNewFile,BufRead *.tf set ft=terraform ]])
  vim.cmd([[au BufNewFile,BufRead *.hcl,*.terraformrc,terraform.rc set ft=hcl ]])
  vim.cmd([[au BufNewFile,BufRead *.tfstate,*.tfstate.backup set ft=json ]])
end

return M
