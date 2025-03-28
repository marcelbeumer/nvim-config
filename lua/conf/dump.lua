-- For pretty printing lua objects (`:lua dump(vim.fn)`)
return function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
  return ...
end
