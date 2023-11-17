local M = {}

M.setup = function()
  local fs = require("conf0.fs")
  local util = require("conf0.util")

  _G.fs = fs
  _G.dump = util.dump
  _G.yank = util.yank
end

return M
