local env = require("conf.env")

local M = {}

local function less_colors()
  local normal_fg = vim.fn.synIDattr(vim.fn.hlID("Normal"), "fg", "gui")

  local syntax_groups = {
    "Comment",
    "String",
    "Character",
    "Number",
    "Boolean",
    "Float",
    "Identifier",
    "Function",
    "Statement",
    "Type",
    "Special",
    "@spell",
  }

  for _, group in ipairs(syntax_groups) do
    vim.api.nvim_set_hl(0, group, { fg = normal_fg })
  end
end

M.setup = function()
  if env.NVIM_DARK == "off" then
    vim.cmd([[set background=light]])
  end

  vim.cmd([[highlight! link ColorColumn CursorLine]])
  vim.api.nvim_create_user_command("LessColors", less_colors, {})
  less_colors()
end

return M
