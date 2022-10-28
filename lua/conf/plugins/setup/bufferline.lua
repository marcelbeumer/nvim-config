local M = {}

M.setup = function()
  local modified_fg = vim.api.nvim_get_hl_by_name("Normal", true).foreground
  require("bufferline").setup({
    options = {
      show_buffer_icons = false,
      indicator = {
        style = "none",
      },
    },
    highlights = {
      buffer_selected = {
        italic = false,
        bold = false,
      },
      modified = {
        fg = modified_fg,
      },
      modified_visible = {
        fg = modified_fg,
      },
      modified_selected = {
        fg = modified_fg,
      },
    },
  })
end

return M
