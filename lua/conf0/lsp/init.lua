local M = {}

M.setup = function()
  local env = require("conf0.env")
  require("conf0.lsp.global").setup()
  require("conf0.lsp.buffer").setup()
  require("conf0.lsp.server.null_ls").setup()
  require("conf0.lsp.server.gopls").setup()
  require("conf0.lsp.server.terraformls").setup()
  require("conf0.lsp.server.lua_language_server").setup()

  if env.NVIM_TS_LSP == "tsserver" then
    require("conf0.lsp.server.tsserver").setup()
  elseif env.NVIM_TS_LSP == "vtsls" then
    require("conf0.lsp.server.vtsls").setup()
  elseif env.NVIM_TS_LSP == "volar" then
    vim.notify("volar lsp not implemented yet", vim.log.levels.WARN)
  end
end

return M
