local M = {}

M.setup = function()
  local fs = require("conf.fs")
  local util = require("conf.util")

  _G.fs = fs
  _G.dump = util.dump
  _G.yank = util.yank
end

return M
