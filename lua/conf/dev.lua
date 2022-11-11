local M = {}

M.setup = function()
  -- For pretty printing lua objects (`:lua dump(vim.fn)`)
  function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
    return ...
  end
end

return M
