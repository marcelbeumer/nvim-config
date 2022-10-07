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
end

return M
