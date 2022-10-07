local M = {}

M.setup = function()
  local env = require("conf.env")
  require("conf.lsp.global").setup()
  require("conf.lsp.buffer").setup()
  require("conf.lsp.server.null_ls").setup()
  require("conf.lsp.server.gopls").setup()
  require("conf.lsp.server.terraformls").setup()
  require("conf.lsp.server.lua_language_server").setup()

  if env.NVIM_TS_LSP == "tsserver" then
    require("conf.lsp.server.tsserver").setup()
  elseif env.NVIM_TS_LSP == "volar" then
    vim.notify("volar lsp not implemented yet", vim.log.levels.WARN)
  end
end

return M
