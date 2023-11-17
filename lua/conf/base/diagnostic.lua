local icons = require("conf.util.icons")

vim.diagnostic.config({
  severity_sort = true,

  -- Verbose:
  -- Virtual tells you what is wrong without having to do a keypress.
  -- Updating in insert mode then gets too noisy.
  virtual_text = { prefix = "●" },
  update_in_insert = false,

  -- Quiet:
  -- Virtual text can be noisy. Downside is that you have to manually
  -- trigger showing diagnostics. Without noisy virtual text it's ok
  -- to update in insert mode.
  -- virtual_text = false,
  -- update_in_insert = true,
})

-- Configure prettier gutter diagnostic signs.
local signs = {
  Error = icons.diagnostics.Error,
  Warn = icons.diagnostics.Warn,
  Hint = icons.diagnostics.Hint,
  Info = icons.diagnostics.Information,
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end
