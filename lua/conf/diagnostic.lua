local M = {}

M.setup = function()
  local icons = require("conf.icons")
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  local diag_modes = {
    -- Virtual tells you what is wrong without having to do a keypress.
    -- Updating in insert mode then gets too noisy.
    verbose = {
      virtual_text = { prefix = "●" },
      update_in_insert = false,
    },
    -- Virtual text can be noisy. Downside is that you have to manually
    -- trigger showing diagnostics (with <space-d> on a specific line).
    -- Without noisy virtual text it's ok to update in insert mode.
    quiet = {
      virtual_text = false,
      update_in_insert = true,
    },
  }

  vim.diagnostic.config(diag_modes.verbose)
  vim.diagnostic.config({
    virtual_lines = false,
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

  local set_verbose = function()
    vim.diagnostic.config(diag_modes.verbose)
  end

  local set_quiet = function()
    vim.diagnostic.config(diag_modes.quiet)
  end

  bind_all("diag.set_verbose", set_verbose, cmd_opts, key_opts)
  bind_all("diag.set_quiet", set_quiet, cmd_opts, key_opts)
  bind_all("diag.toggle_signs", toggle_signs, cmd_opts, key_opts)
  bind_all("diag.toggle_virtual_lines", toggle_virtual_lines_all, cmd_opts, key_opts)
  bind_all("diag.toggle_virtual_lines_current_only", toggle_virtual_lines_current, cmd_opts, key_opts)
  bind_all("diag.show_line", vim.diagnostic.open_float, cmd_opts, key_opts)
  bind_all("diag.prev", vim.diagnostic.goto_prev, cmd_opts, key_opts)
  bind_all("diag.next", vim.diagnostic.goto_next, cmd_opts, key_opts)
  bind_all("diag.set_loclist", vim.diagnostic.setloclist, cmd_opts, key_opts)

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
end

return M
