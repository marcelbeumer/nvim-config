local M = {}

M.default = ""
M.np_small = "no_preview_small"
M.np_large = "no_preview_slarge"

M.handler = function(method, type)
  local opts = {}

  if type == M.np_small then
    opts = { previewer = false, winopts = { width = 0.6, height = 20 } }
  elseif type == M.np_large then
    opts = { previewer = false, winopts = { width = 0.6, height = 0.80 } }
  end

  return function()
    require("fzf-lua")[method](opts)
  end
end

return M
