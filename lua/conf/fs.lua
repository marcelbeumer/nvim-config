local M = {}

M.cd = function(path)
  vim.cmd("cd " .. path)
end

M.cwd = function()
  return vim.fn.getcwd()
end

M.tree_cd = function(path)
  local abs_path = vim.loop.fs_realpath(path)
  require("conf.plugins.setup.nvim_tree").set_tree_cwd(abs_path)
end

M.tree_cwd = function()
  return require("conf.plugins.setup.nvim_tree").tree_cwd()
end

M.file_path = function()
  return vim.fn.expand("%")
end

M.file_path_abs = function()
  return vim.fn.expand("%:p")
end

M.file_name = function()
  return vim.fn.expand("%:t")
end

M.file_ext = function()
  return vim.fn.expand("%:e")
end

M.root_dir = function(from, patterns)
  from = from or M.cwd()
  patterns = patterns or { ".git" }
  return vim.fs.dirname(vim.fs.find(patterns, { upward = true, path = from })[1])
end

return M
