local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  vim.diagnostic.config({
    virtual_lines = false,
    -- Virtual text is too noisy IMO. Downside is that you have to manually
    -- trigger showing diagnostics (with <space-e> on a specific line).
    virtual_text = false,
    -- Without noisy virtual text it's ok to update in insert mode.
    update_in_insert = true,
    -- Put errors on top.
    severity_sort = true,
  })

  local toggle_signs = function()
    local signs = not vim.diagnostic.config().signs
    vim.diagnostic.config({ signs = signs })
  end

  local toggle_virtual_lines = function(only_current_line)
    local new_value = not vim.diagnostic.config().virtual_lines
    if new_value and only_current_line then
      vim.diagnostic.config({ virtual_lines = {
        only_current_line = true,
      } })
    else
      vim.diagnostic.config({ virtual_lines = new_value })
    end
    return new_value
  end

  local toggle_virtual_lines_all = function()
    toggle_virtual_lines()
  end

  local toggle_virtual_lines_current = function()
    toggle_virtual_lines(true)
  end

  bind_all("diag.toggle_signs", toggle_signs, cmd_opts, key_opts)
  bind_all("diag.toggle_virtual_lines", toggle_virtual_lines_all, cmd_opts, key_opts)
  bind_all("diag.toggle_virtual_lines_current_only", toggle_virtual_lines_current, cmd_opts, key_opts)
  bind_all("diag.show_line", vim.diagnostic.open_float, cmd_opts, key_opts)
  bind_all("diag.prev", vim.diagnostic.goto_prev, cmd_opts, key_opts)
  bind_all("diag.next", vim.diagnostic.goto_next, cmd_opts, key_opts)
  bind_all("diag.set_loclist", vim.diagnostic.setloclist, cmd_opts, key_opts)

  -- Configure prettier gutter diagnostic signs.
  local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
  -- local signs = { Hint = "", Info = "", Warn = "", Error = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end
end

return M
