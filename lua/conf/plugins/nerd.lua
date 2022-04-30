local M = {}

M.setup = function()
	vim.cmd([[
    let NERDTreeShowHidden=1
    let NERDTreeWinSize=35
    nnoremap <silent><leader>; :NERDTreeToggle<CR>
    nnoremap <silent><leader>' :NERDTreeFind<CR>
  ]])
end

return M
