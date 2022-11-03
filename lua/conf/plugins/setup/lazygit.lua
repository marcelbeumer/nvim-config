local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  bindings.bind_all("git.open_lazygit", ":LazyGit<cr>", {}, {})
end

return M
