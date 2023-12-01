local M = {}

M.addCursor = function()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local bufnr = vim.fn.bufnr("%")
  local entry = { filename = vim.fn.bufname(bufnr), lnum = vim.fn.line("."), col = col, text = line }
  vim.fn.setqflist({ entry }, "a")
end

M.removeCursor = function()
  local current_line = vim.fn.line(".")
  local qflist = vim.fn.getqflist()
  local new_qflist = vim.tbl_filter(function(item)
    return item.lnum ~= current_line
  end, qflist)
  vim.fn.setqflist(new_qflist)
end

M.removeCurr = function()
  local qf_idx = vim.fn.getqflist({ idx = 0 }).idx
  if qf_idx > 0 then
    local qflist = vim.fn.getqflist()
    table.remove(qflist, qf_idx)
    vim.fn.setqflist(qflist, "r")
  end
end

M.moveCurrUp = function()
  local qf_idx = vim.fn.getqflist({ idx = 0 }).idx
  local qflist = vim.fn.getqflist()
  if qf_idx > 1 and qf_idx <= #qflist then
    local temp = qflist[qf_idx - 1]
    qflist[qf_idx - 1] = qflist[qf_idx - 2]
    qflist[qf_idx - 2] = temp
    vim.fn.setqflist({}, "r", { items = qflist, idx = qf_idx - 1 })
  end
end

M.moveCurrDown = function()
  local qf_idx = vim.fn.getqflist({ idx = 0 }).idx
  local qflist = vim.fn.getqflist()
  if qf_idx > 0 and qf_idx < #qflist then
    local temp = qflist[qf_idx]
    qflist[qf_idx] = qflist[qf_idx + 1]
    qflist[qf_idx + 1] = temp
    vim.fn.setqflist({}, "r", { items = qflist, idx = qf_idx + 1 })
  end
end

M.save = function(filepath)
  local qflist = vim.fn.getqflist()
  local file = io.open(filepath, "w")
  if file then
    for _, item in ipairs(qflist) do
      local filename = ""
      if item.bufnr and item.bufnr > 0 then
        filename = vim.fn.bufname(item.bufnr)
      end

      if not filename or filename == "" then
        filename = "nofile"
      else
        filename = vim.fn.fnameescape(filename)
      end

      file:write(filename .. ":" .. item.lnum .. ":" .. item.col .. ":" .. (item.text or "") .. "\n")
    end
    file:close()
  else
    print("Unable to open file for writing: " .. filepath)
  end
end

M.load = function(filepath)
  local file = io.open(filepath, "r")
  if file then
    local lines = {}
    for line in file:lines() do
      local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.+)")
      table.insert(lines, { filename = filename, lnum = tonumber(lnum), col = tonumber(col), text = text })
    end
    vim.fn.setqflist(lines)
    file:close()
  else
    print("Unable to open file for reading: " .. filepath)
  end
end

M.setup = function()
  vim.keymap.set("n", "<leader>qa", M.addCursor, {})
  vim.keymap.set("n", "<leader>qd", M.removeCursor, {})

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      local opts = { buffer = 0 }
      vim.keymap.set("n", "dd", M.removeCurr, opts)
      vim.keymap.set("n", "<C-j>", M.moveCurrDown, opts)
      vim.keymap.set("n", "<C-k>", M.moveCurrUp, opts)
    end,
  })

  vim.api.nvim_create_user_command("QuickfixSave", function(args)
    local filepath = args.args
    if filepath == "" then
      print("Please provide a filename.")
      return
    end
    M.save(filepath)
  end, { nargs = 1 })

  vim.api.nvim_create_user_command("QuickfixLoad", function(args)
    local filepath = args.args
    if filepath == "" then
      print("Please provide a filename.")
      return
    end
    M.load(filepath)
  end, { nargs = 1 })
end

return M
