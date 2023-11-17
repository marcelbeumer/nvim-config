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

-- Line wrapping.
vim.o.linebreak = true
vim.o.breakat = " ^I!@-+;:,./?" -- removed "*" from default

vim.api.nvim_set_var("netrw_banner", 0)
vim.api.nvim_set_var("netrw_altv", 1)
