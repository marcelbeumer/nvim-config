return function(v, _)
  local result = pcall(function()
    vim.cmd('let @*="' .. vim.fn.escape(v, '" \\') .. '"')
  end)
  if not result then
    print("Could not set @* with value: " .. v)
  end
end
