local icons = require("conf.util.icons")

local M = {}

M.statusline = function()
  local opts = { severity = vim.diagnostic.severity.ERROR }
  local has_errors = #vim.diagnostic.get(0, opts) > 0

  local error
  if has_errors then
    error = icons.diagnostics.Error
  else
    error = " "
  end

  local file_path = "%f"
  local line_col = "%l,%c  "
  local position = "%P"

  return string.format("%s %%=%s %s %s", file_path, error, line_col, position)
end

M.setup = function()
  vim.o.statusline = "%!v:lua.require('conf.extra.statusline').statusline()"

  vim.cmd([[
    augroup UpdateStatusline
      autocmd!
      autocmd DiagnosticChanged * redrawstatus
    augroup END
  ]])
end

return M
