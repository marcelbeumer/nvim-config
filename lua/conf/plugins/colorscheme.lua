local env = require("conf.env")

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      styles = {
        comments = "NONE",
        keywords = "NONE",
      },
      on_highlights = function(hl)
        if env.NVIM_SYNTAX_HIGHLIGHT == "off" then
          hl.FloatBorder = hl.Normal
        end
      end,
    },
  },
}
