local icons = require("conf.util.icons")

local M = {}

local diagnostics_cached = ""

local diagnostics = function()
  if diagnostics_cached ~= "" then
    return diagnostics_cached
  end

  local diagnostics = vim.diagnostic.get(0, {})
  local severity = vim.diagnostic.severity
  local icons = icons.diagnostics
  local icons = {
    [severity.ERROR] = icons.Error,
    [severity.WARN] = icons.Warning,
    [severity.HINT] = icons.Hint,
    [severity.INFO] = icons.Information,
  }
  local counts = {
    [severity.ERROR] = 0,
    [severity.WARN] = 0,
    [severity.HINT] = 0,
    [severity.INFO] = 0,
  }
  for _, d in ipairs(diagnostics) do
    counts[d.severity] = counts[d.severity] + 1
  end

  local status = ""
  for severity, count in pairs(counts) do
    if count > 0 then
      status = status .. string.format("%s %d ", icons[severity], count)
    end
  end

  diagnostics_cached = status
  return status
end

M.statusline = function()
  local file_path = "%f"
  local line_col = "%8(%l,%c%)"
  local position = "%5P"

  return string.format("%s %%=%s %s %s", file_path, diagnostics(), line_col, position)
end

M.setup = function()
  vim.o.statusline = "%!v:lua.require('conf.extra.statusline').statusline()"
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      diagnostics_cached = ""
      vim.cmd("redrawstatus")
    end,
    group = vim.api.nvim_create_augroup("UpdateStatusline", { clear = true }),
  })
end

return M
