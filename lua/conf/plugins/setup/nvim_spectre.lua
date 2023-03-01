local M = {}

M.setup = function()
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  local spectre = require("spectre")
  spectre.setup({})
  bind_all("spectre.open", spectre.open, {}, key_opts)
  bind_all("spectre.open_file", spectre.open_file_search, {}, key_opts)
end

return M
