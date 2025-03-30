local icons = require("conf.icons")

local M = {}

local diagnostics_cached = ""

local diagnostics = function()
  if diagnostics_cached ~= "" then
    return diagnostics_cached
  end

  local diagnostics = vim.diagnostic.get(0, {})
  local severity = vim.diagnostic.severity
  local diag_icon = {
    [severity.ERROR] = icons.diagnostics.Error,
    [severity.WARN] = icons.diagnostics.Warning,
    [severity.HINT] = icons.diagnostics.Hint,
    [severity.INFO] = icons.diagnostics.Information,
  }
  local totals = {
    [severity.ERROR] = 0,
    [severity.WARN] = 0,
    [severity.HINT] = 0,
    [severity.INFO] = 0,
  }
  for _, d in ipairs(diagnostics) do
    totals[d.severity] = totals[d.severity] + 1
  end

  local status = ""
  for level, total in pairs(totals) do
    if total > 0 then
      status = status .. string.format("%s %d ", diag_icon[level], total)
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

local function debounce(callback, delay)
  local timer = nil
  return function()
    if timer then
      return
    end
    timer = vim.defer_fn(function()
      timer = nil
      callback()
    end, delay)
  end
end

M.setup = function()
  vim.o.statusline = "%!v:lua.require('conf.statusline').statusline()"

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = debounce(function()
      diagnostics_cached = ""
      vim.cmd.redrawstatus()
    end, 200),
    group = vim.api.nvim_create_augroup("UpdateStatusline", { clear = true }),
  })
end

return M
