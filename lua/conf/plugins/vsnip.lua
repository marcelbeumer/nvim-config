local M = {}

M.setup = function()
	vim.cmd([[
    let g:vsnip_filetypes = {}
    let g:vsnip_filetypes.javascriptreact = ['javascript']
    let g:vsnip_filetypes.typescriptreact = ['typescript']
    let g:vsnip_snippet_dir = expand('~/.config/nvim/vsnip')
  ]])
end

return M
