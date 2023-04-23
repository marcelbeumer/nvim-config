local M = {}

-- https://www.reddit.com/r/neovim/comments/12w3g5b/my_little_theme_cycler/
local function theme_cycler()
  local state = 0
  local themes = {
    "everforest",
    "catppuccin",
    "kanagawa",
    "palenightfall",
    "nordic",
    "fleet",
    "tokyonight",
  }
  return function()
    state = (state + 1) % #themes
    local theme = themes[state + 1]
    vim.cmd.colorscheme(theme)
    print(theme)
  end
end

M.setup = function()
  local bind_all = require("conf.bindings").bind_all
  bind_all("colorscheme.next", theme_cycler(), {}, {})

  vim.cmd.colorscheme("tokyonight")
end

return M
