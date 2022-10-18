local M = {}

local yank = function(v, _)
  local result = pcall(function()
    vim.cmd('let @*="' .. vim.fn.escape(v, '" \\') .. '"')
  end)
  if not result then
    print("Could not set @* with value: " .. v)
  end
end

local cd = function(v, _)
  vim.cmd("cd " .. v)
end

M.api = {}

M.api.tree = function(value, opts)
  local target_cwd = value
  if opts and opts.cwd then
    target_cwd = vim.fn.getcwd()
  end

  if target_cwd then
    local abs_target = vim.loop.fs_realpath(target_cwd)
    require("conf.plugins.setup.nvim_tree").set_tree_cwd(abs_target)
  end

  local tree_cwd = require("conf.plugins.setup.nvim_tree").tree_cwd()

  if opts and opts.cd then
    cd(tree_cwd)
  end

  yank(tree_cwd, opts)
  return tree_cwd
end

M.api.root = function(values, opts)
  local from = vim.fn.expand("%:p")
  if opts and opts.cwd then
    from = vim.fn.getcwd(0, 0)
  end

  local patterns = values or { ".git" }
  local root_dir = vim.fs.dirname(vim.fs.find(patterns, { upward = true, path = from })[1])
  if not root_dir then
    yank("")
    return
  end

  if opts and opts.cd then
    cd(root_dir)
  end

  if opts and opts.tree then
    M.api.tree(root_dir)
  end

  yank(root_dir)
  return root_dir
end

M.api.cwd = function(value, opts)
  if value then
    cd(value)
  end
  local cwd = vim.fn.getcwd()
  if opts and opts.tree then
    M.api.tree(cwd)
  end
  yank(cwd)
  return cwd
end

M.api.filePath = function()
  local v = vim.fn.expand("%:p")
  yank(v)
  return v
end

M.api.filePathRel = function()
  local v = vim.fn.expand("%:p")
  yank(v)
  return v
end

M.api.fileName = function()
  local v = vim.fn.expand("%:t")
  yank(v)
  return v
end

M.api.fileExt = function()
  local v = vim.fn.expand("%:e")
  yank(v)
  return v
end

M.setup = function()
  local contains = function(value, list)
    for _, v in ipairs(list) do
      if v == value then
        return v
      end
    end
    return false
  end

  local parse_opts = function(args, opts_spec)
    local opts = {}
    local values = nil
    local fargs = args.fargs
    for _, v in ipairs(fargs or {}) do
      if v:sub(1, 1) == "+" then
        local opt = v:sub(2)
        if not opts_spec or contains(opt, opts_spec) then
          opts[v:sub(2)] = true
        else
          error("opt " .. opt .. " not allowed")
        end
      else
        if values == nil then
          values = {}
        end
        table.insert(values, v)
      end
    end
    return values, opts
  end

  local with_opts = function(fn, allowed)
    return function(args)
      local _, opts = parse_opts(args, allowed)
      print(fn(opts))
    end
  end

  local with_values = function(fn, allowed)
    return function(args)
      local values, opts = parse_opts(args, allowed)
      print(fn(values, opts))
    end
  end

  local with_value = function(fn, allowed)
    return function(args)
      local values, opts = parse_opts(args, allowed)
      print(fn((values or {})[1], opts))
    end
  end

  vim.api.nvim_create_user_command("Cwd", with_value(M.api.cwd, { "tree" }), { nargs = "*", complete = "file" })
  vim.api.nvim_create_user_command("Root", with_values(M.api.root, { "cd", "tree", "cwd" }), { nargs = "*" })
  vim.api.nvim_create_user_command("Tree", with_value(M.api.tree, { "cd", "cwd" }), { nargs = "*", complete = "file" })

  vim.api.nvim_create_user_command("FilePath", with_opts(M.api.filePath, {}), {})
  vim.api.nvim_create_user_command("FilePathRel", with_opts(M.api.filePathRel, {}), {})
  vim.api.nvim_create_user_command("FileName", with_opts(M.api.fileName, {}), {})
  vim.api.nvim_create_user_command("FileExt", with_opts(M.api.fileExt, {}), {})
end

return M
