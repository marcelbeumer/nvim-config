-- Module fs.
local M = {}

-- M.find_repo_root = function() end

M.setup = function()
  -- `+tree` to change nvim tree too.
  vim.api.nvim_buf_create_user_command("Cwd", {})

  -- `+cd` to change dir too.
  -- `+tree` to change nvim tree too.
  -- `+git` to force git as root.
  vim.api.nvim_buf_create_user_command("Root", {})
  -- `+cd` to change dir too.
  vim.api.nvim_buf_create_user_command("Tree", {}) --
  -- `+cd` to change dir too.
  -- `+cwd`to use cwd
  -- `<path>` target path (last arg)
  vim.api.nvim_buf_create_user_command("TreeSet", {})

  vim.api.nvim_buf_create_user_command("FilePath", {})
  vim.api.nvim_buf_create_user_command("FilePathRel", {})
  vim.api.nvim_buf_create_user_command("FileName", {})
  vim.api.nvim_buf_create_user_command("FileExt", {})
end

return M
