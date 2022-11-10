local M = {}

M.setup = function()
  -- Global commands.
  vim.api.nvim_create_user_command("LspAutoFormatStatus", function()
    print(require("conf.env").NVIM_LSP_AUTO_FORMAT)
  end, {})
  vim.api.nvim_create_user_command("LspAutoFormatEnable", function()
    require("conf.env").NVIM_LSP_AUTO_FORMAT = "on"
  end, {})
  vim.api.nvim_create_user_command("LspAutoFormatDisable", function()
    require("conf.env").NVIM_LSP_AUTO_FORMAT = "off"
  end, {})
  vim.api.nvim_create_user_command("LspStatus", function()
    dump(vim.lsp.buf_get_clients())
  end, {})
  vim.api.nvim_create_user_command("LspShutdown", function()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      client.stop()
    end
  end, {})
end

return M
