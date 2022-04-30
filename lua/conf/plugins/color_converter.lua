local M = {}

M.setup = function()
	vim.cmd([[
    command! ColorConvertHEX lua require('color-converter').to_hex()<CR>
    command! ColorConvertRGB lua require('color-converter').to_rgb()<CR>
    command! ColorConvertHSL lua require('color-converter').to_hsl()<CR>
  ]])
end

return M
