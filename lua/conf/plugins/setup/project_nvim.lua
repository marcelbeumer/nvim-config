local M = {}

M.setup = function()
  require("project_nvim").setup({ manual_mode = true, show_hidden = true })
end

return M
