local M = {}

M.init = function()
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  bind_all("session.load", function()
    require("persistence").load() -- lazy
  end, {}, key_opts)
end

M.config = function()
  require("persistence").setup()
end

return M
