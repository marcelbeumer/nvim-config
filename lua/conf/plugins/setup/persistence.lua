local M = {}

M.init = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  bind_all("session.load", function()
    require("persistence").load()
  end, cmd_opts, key_opts)
end

M.config = function()
  require("persistence").setup()
end

return M
