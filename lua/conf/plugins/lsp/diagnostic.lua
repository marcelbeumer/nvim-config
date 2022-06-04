local noise_level = 3

local function setup_internal()
  vim.diagnostic.config({
    signs = noise_level >= 1,
    underline = noise_level >= 2,
    virtual_text = noise_level >= 3,
    -- update_in_insert = true,
    severity_sort = true,
  })
  local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end
end

local M = {}

function M.set_noise_level(level)
  if level == nil then
    print(noise_level)
    return
  end
  noise_level = tonumber(level)
  setup_internal()
  vim.diagnostic.hide()
  vim.diagnostic.show()
end

function M.setup()
  setup_internal()
  vim.cmd(
    [[command! -nargs=? DiagnosticNoiseLevel ]]
      .. [[lua require("conf.plugins.lsp.diagnostic").set_noise_level(<args>)<CR>]]
  )
end

return M
