local M = {}

M.setup = function()
  require("tokyonight").setup({
    style = "moon",
    styles = {
      comments = "NONE",
      keywords = "NONE",
    },
  })
  vim.cmd.colorscheme("tokyonight")
end

return M
