local icons = require("conf.icons")

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  float = {
    border = "rounded",
  },
})

-- Configure prettier gutter diagnostic signs.
local signs = {
  Error = icons.diagnostics.Error,
  Warn = icons.diagnostics.Warning,
  Hint = icons.diagnostics.Hint,
  Info = icons.diagnostics.Information,
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end
