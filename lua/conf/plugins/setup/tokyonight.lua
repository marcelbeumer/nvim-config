local M = {}

M.setup = function()
  require("tokyonight").setup({
    style = "storm",
    styles = {
      comments = "NONE",
      keywords = "NONE",
    },
  })
  vim.cmd.colorscheme("tokyonight")
end

return M
