local M = {}

for _, item in ipairs({
  require("conf.plugins.lang.lua"),
  require("conf.plugins.lang.python"),
  require("conf.plugins.lang.terraform"),
  require("conf.plugins.lang.typescript"),
  require("conf.plugins.lang.go"),
}) do
  table.insert(M, item)
end

return M
