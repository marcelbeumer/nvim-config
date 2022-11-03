local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local key_opts = { noremap = true, silent = true }
  require("hop").setup()
  bindings.bind_all("hop_motion.forward", ":HopWordAC<cr>", {}, key_opts)
  bindings.bind_all("hop_motion.backward", ":HopWordBC<cr>", {}, key_opts)
end

return M
