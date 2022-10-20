local M = {}

M.setup = function()
  require("dressing").setup({
    input = {
      enabled = false,
    },
    select = {
      backend = { "fzf_lua", "builtin" },
    },
  })
end

return M
