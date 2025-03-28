local M = {}

M.setup = function()
  local yank = require("conf.yank")
  local fs = require("conf.fs")

  local yank_fn = function(fn)
    return function()
      yank(fn())
    end
  end

  vim.api.nvim_create_user_command("FilePath", yank_fn(fs.file_path), {})
  vim.api.nvim_create_user_command("FilePathAbs", yank_fn(fs.file_path_abs), {})
end

return M
