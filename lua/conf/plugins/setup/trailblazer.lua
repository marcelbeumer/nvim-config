local M = {}

M.setup = function()
  require("trailblazer").setup({
    trail_options = {
      trail_mark_symbol_line_indicators_enabled = false,
      newest_mark_symbol = "",
      cursor_mark_symbol = "",
      next_mark_symbol = "",
      previous_mark_symbol = "",
      multiple_mark_symbol_counters_enabled = "",
      number_line_color_enabled = false,
      symbol_line_enabled = false,
    },
  })
end

return M
