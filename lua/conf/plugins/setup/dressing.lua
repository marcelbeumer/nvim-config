local M = {}

M.setup = function()
  require("dressing").setup({
    input = {
      border = "solid",
      relative = "editor",
      prompt_align = "left",
    },
    select = {
      builtin = {
        border = "solid",
      },
      backend = { "builtin" },
    },
  })
end

return M
