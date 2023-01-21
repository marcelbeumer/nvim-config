local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  local spectre = require("spectre")
  spectre.setup({})
  bind_all("spectre.open", spectre.open, cmd_opts, key_opts)
  bind_all("spectre.open_file", spectre.open_file_search, cmd_opts, key_opts)
end

return M
