return function(v, _)
  local ok = pcall(function()
    vim.fn.setreg("+", v)
  end)
  if not ok then
    print("Could not set @+ with value: " .. v)
  end
end
