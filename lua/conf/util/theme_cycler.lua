-- https://www.reddit.com/r/neovim/comments/12w3g5b/my_little_theme_cycler/
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
