local M = {}

-- For pretty printing lua objects (`:lua dump(vim.fn)`)
M.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end

M.yank = function(v, _)
  local result = pcall(function()
    vim.cmd('let @*="' .. vim.fn.escape(v, '" \\') .. '"')
  end)
  if not result then
    print("Could not set @* with value: " .. v)
  end
end

return M
