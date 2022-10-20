local M = {}

M.setup = function()
  -- For pretty printing lua objects (`:lua dump(vim.fn)`)
  function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
    return ...
  end

  -- Line numbers.
  vim.o.number = true
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
  -- Show search result counter
  vim.opt.shortmess:remove({ "-S" })

  -- Netrw settings.
  vim.api.nvim_set_var("netrw_banner", 0)
  vim.api.nvim_set_var("netrw_altv", 1)

  -- Highlight yanked text.
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- Too many typos but too stubborn to map to smth else.
  vim.cmd([[command W w]])

  vim.keymap.set("n", "]q", ":cnext<CR>")
  vim.keymap.set("n", "[q", ":cprev<CR>")
  vim.keymap.set("n", "]Q", ":lnext<CR>")
  vim.keymap.set("n", "[Q", ":lprev<CR>")
  vim.keymap.set("n", "]t", ":tabnext<CR>")
  vim.keymap.set("n", "[t", ":tabprev<CR>")
  -- vim.keymap.set("n", "<C-x>", ":b#|bd#<CR>")
  -- vim.keymap.set("n", "<C-L>", ":tabnext<CR>")
  -- vim.keymap.set("n", "<C-H>", ":tabprev<CR>")
  vim.keymap.set("n", "<C-s>", ":w<CR>")
  vim.keymap.set("n", "<C-w>N", ":vnew<CR>")
  vim.keymap.set("n", "<leader>t", function() end, { desc = "Tabs..." })
  vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
  vim.keymap.set("n", "<leader>tb", ":tab sb %<CR>")
  vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")
  vim.keymap.set("n", "<leader>n", ":set nu!<CR>")
  vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
  vim.keymap.set("n", "<leader>s", ":split<CR>")
  vim.keymap.set("n", "<leader>x", function() end, { desc = "Misc..." })

  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], {})
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], {})
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], {})
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], {})

  -- https://vi.stackexchange.com/questions/21260/how-to-clear-neovim-terminal-buffer#21364
  vim.cmd([[
    nmap <c-w><c-l> :set scrollback=1 \| sleep 100m \| set scrollback=10000<cr>
    tmap <c-w><c-l> <c-\><c-n><c-w><c-l>i<c-l>
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

  -- Terraform
  vim.cmd([[au BufNewFile,BufRead *.tf set ft=terraform ]])
  vim.cmd([[au BufNewFile,BufRead *.hcl,*.terraformrc,terraform.rc set ft=hcl ]])
  vim.cmd([[au BufNewFile,BufRead *.tfstate,*.tfstate.backup set ft=json ]])
end

return M
