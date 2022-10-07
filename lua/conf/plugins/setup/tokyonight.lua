local M = {}

M.setup = function()
  require("tokyonight").setup({
    style = "moon",
    styles = {
      comments = "NONE",
      keywords = "NONE",
    },
  })
end

return M
