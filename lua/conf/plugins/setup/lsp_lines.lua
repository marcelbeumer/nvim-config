local M = {}

M.setup = function()
  vim.diagnostic.config({ virtual_lines = false })
  require("lsp_lines").setup()

  vim.api.nvim_create_user_command("LspLinesToggle", function()
    require("lsp_lines").toggle()
  end, {})
  vim.api.nvim_create_user_command("LspLinesDisable", function()
    vim.diagnostic.config({ virtual_lines = false })
  end, {})
  vim.api.nvim_create_user_command("LspLinesEnable", function()
    vim.diagnostic.config({ virtual_lines = true })
  end, {})
  vim.api.nvim_create_user_command("LspLinesEnableCurrentLine", function()
    vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
  end, {})
  vim.keymap.set("n", "<leader>l", require("lsp_lines").toggle, { desc = "Toggle diagnostic virtual lines" })
end

return M
