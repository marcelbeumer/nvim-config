local M = {}

M.setup = function()
  -- local path = vim.fn.stdpath("data") .. "/sessions/"
  -- local dir = vim.fn.expand(path, false, nil)
  -- local persistence = require("persistence")
  -- persistence.setup({ dir = dir })
  -- vim.api.nvim_create_user_command("LoadSession", persistence.load, {})
  -- vim.api.nvim_create_user_command("SaveSession", persistence.save, {})
  -- vim.api.nvim_create_user_command("StopSession", persistence.stop, {})
  require("persisted").setup()
end

return M
