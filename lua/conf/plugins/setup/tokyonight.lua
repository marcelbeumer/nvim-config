local M = {}

M.setup = function()
  require("tokyonight").setup({
    style = "night",
    styles = {
      comments = "NONE",
      keywords = "NONE",
    },
  })
end

return M
