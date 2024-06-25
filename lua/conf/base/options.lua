local env = require("conf.env")

vim.o.termguicolors = true
-- Use clipboard provider.
vim.o.clipboard = "unnamedplus"
-- Line numbers.
vim.o.number = true
vim.o.relativenumber = true
--Enable break indent.
vim.o.breakindent = true
--Case insensitive searching UNLESS /C or capital in search.
vim.o.ignorecase = true
vim.o.smartcase = true
--Decrease update time.
vim.o.updatetime = 250
-- Space for LSP signs etc.
vim.o.signcolumn = "yes"
-- Keep some space when scrolling.
vim.o.scrolloff = 5
-- Highlight current line
vim.o.cursorline = true
-- Simple folding
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
-- Omnicomplete
vim.o.completeopt = "menu,menuone,noinsert"

-- Line wrapping.
vim.o.linebreak = true
vim.o.breakat = " ^I!@-+;:,./?" -- removed "*" from default

if env.NVIM_SYNTAX == "off" then
  vim.cmd.syntax("off")
end
