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
        if env.NVIM_SYNTAX == "off" then
          hl.FloatBorder = hl.Normal
        end
      end,
    },
  },

  {
    "savq/melange-nvim",
    priority = 1000,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      -- color_overrides = {
      --   latte = {
      --     base = "#FFFFDB", -- acme
      --   },
      -- },
      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.overlay2 },
        }
      end,
    },
  },
}
