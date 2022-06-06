local M = {}

M.setup = function()
  function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
    return ...
  end

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

  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  vim.cmd([[command W w]])
  vim.cmd([[command FilePath let @*=expand("%")]])
  vim.cmd([[command FilePathAbs let @*=expand("%:p")]])
  vim.cmd([[command FilePathHead let @*=expand("%:h")]])
  vim.cmd([[command FilePathTail let @*=expand("%:t")]])

  vim.keymap.set("n", "]q", ":cnext")
  vim.keymap.set("n", "]q", ":cnext<CR>")
  vim.keymap.set("n", "[q", ":cprev<CR>")
  vim.keymap.set("n", "]Q", ":lnext<CR>")
  vim.keymap.set("n", "[Q", ":lprev<CR>")
  vim.keymap.set("n", "]t", ":tabnext<CR>")
  vim.keymap.set("n", "[t", ":tabprev<CR>")
  vim.keymap.set("n", "<C-L>", ":tabnext<CR>")
  vim.keymap.set("n", "<C-H>", ":tabprev<CR>")
  vim.keymap.set("n", "<C-s>", ":w<CR>")
  vim.keymap.set("n", "<C-w>N", ":vnew<CR>")
  vim.keymap.set("n", "<leader>s", ":w<CR>")
  vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
  vim.keymap.set("n", "<leader>tb", ":tab sb %<CR>")
  vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")
  vim.keymap.set("n", "<leader>bd", ":bdel<CR>")

  vim.cmd([[
    function! DateStrPretty() range
      return system('date "+%Y-%m-%d %H:%M:%S" | tr -d "\n"')
    endfunction

    function! DateStrFs() range
      return system('date "+%Y-%m-%d-%H%M-%S" | tr -d "\n"')
    endfunction
  ]])
end

return M