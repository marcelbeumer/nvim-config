local M = {}

M.setup = function()
  vim.diagnostic.config({
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

  local toggle_signs_desc = "Toggle diagnostic signs"
  vim.keymap.set("n", "<leader>xs", toggle_signs, { desc = toggle_signs_desc })
  vim.api.nvim_create_user_command("LspToggleSigns", toggle_signs, { desc = toggle_signs_desc })

  -- Configure prettier gutter diagnostic signs.
  local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
  -- local signs = { Hint = "", Info = "", Warn = "", Error = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
end

return M
