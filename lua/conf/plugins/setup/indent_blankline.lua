local M = {}

M.setup = function()
  require("ibl").setup({
    enabled = false,
    -- for example, context is off by default, use this to turn it on
    -- show_current_context = true,
    -- show_current_context_start = true,
  })
end

return M
