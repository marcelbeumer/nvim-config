local M = {}

M.setup = function()
  local util = require("conf.util")
  _G.dump = util.dump
  _G.yank = util.yank
end

return M
