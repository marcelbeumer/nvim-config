local M = {}

-- IDEAS:
-- * add cursor line to bookmarks, storing in bookmarks *file*
-- * remove cursor line from bookmarks, removing in bookmarks *file*
-- * load bookmarks file in quickfix
-- * bookmarks file per cwd (in stddata) or global?
-- * be able to yank (ctrl-y rather) from quickfix and get good qf items
-- * be able to put (ctrl-p rather) to quickfix and add good qf items
-- * or be able to edit the quickfix in another window and bring back the results
-- * or bookmarks in memory? can always Load/Save
-- * Workflow, add to bookmarks (mem), add to bookmarks (mem), (clear/set qf for lsp or whatever), call .loadBookmarks, modify qf list... (adding to bookmarks will not show in qf automatically)... .saveBookmarks saves current qf as bookmarks.

local entry_from_qfitem = function(item)
  local filename = ""
  if item.bufnr and item.bufnr > 0 then
    filename = vim.fn.bufname(item.bufnr)
  end
  if not filename or filename == "" then
    filename = "nofile"
  else
    filename = vim.fn.fnameescape(filename)
  end
  return { filename = filename, lnum = item.lnum, col = item.col, text = item.text or "" }
end

M.remove_idx = function(idx)
  local qflist = vim.fn.getqflist()
  local newlist = {}
  for i, item in ipairs(qflist) do
    if i ~= idx then
      newlist[#newlist + 1] = item
    end
  end
  vim.fn.setqflist(newlist, "r")
end

M.entry_at_idx = function(idx)
  local qflist = vim.fn.getqflist()
  local item = qflist[idx]
  if not item then
    return nil
  end
  return entry_from_qfitem(item)
end

M.entry_from_pos = function()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local bufnr = vim.fn.bufnr("%")
  return { filename = vim.fn.bufname(bufnr), lnum = vim.fn.line("."), col = col, text = line }
end

M.add_from_pos = function()
  local entry = M.entry_from_pos()
  vim.fn.setqflist({ entry }, "a")
end

M.remove_current = function()
  local idx = vim.fn.getqflist({ idx = 0 }).idx
  M.remove_idx(idx)
end

M.move_current_up = function()
  local line = vim.fn.line(".")
  local qflist = vim.fn.getqflist()
  if line > 1 and line <= #qflist then
    local temp = qflist[line]
    qflist[line] = qflist[line - 1]
    qflist[line - 1] = temp
    vim.fn.setqflist({}, "r", { items = qflist })
    vim.fn.setpos(".", { 0, line - 1, 0, 0 })
  end
end

M.move_current_down = function()
  local line = vim.fn.line(".")
  local qflist = vim.fn.getqflist()
  if line > 0 and line < #qflist then
    local temp = qflist[line]
    qflist[line] = qflist[line + 1]
    qflist[line + 1] = temp
    vim.fn.setqflist({}, "r", { items = qflist })
    vim.fn.setpos(".", { 0, line + 1, 0, 0 })
  end
end

M.save = function(filepath)
  local qflist = vim.fn.getqflist()
  local file = io.open(filepath, "w")
  if file then
    for _, item in ipairs(qflist) do
      local entry = entry_from_qfitem(item)
      file:write(entry.filename .. ":" .. entry.lnum .. ":" .. entry.col .. ":" .. entry.text .. "\n")
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
  vim.keymap.set("n", "<leader>qq", function()
    local open = vim.fn.getqflist({ winid = 0 }).winid ~= 0
    if open then
      vim.cmd("cclose")
    else
      vim.cmd("copen")
    end
  end, {})

  vim.keymap.set("n", "<leader>qa", M.add_from_pos, {})
  -- vim.keymap.set("n", "<leader>qb", M.bookmark, {})
  -- vim.keymap.set("n", "<leader>ql", M.loadBookmarks, {})
  -- vim.keymap.set("n", "<leader>qs", M.saveBookmarks, {})

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      local opts = { buffer = 0 }
      vim.keymap.set("n", "<C-d>", M.remove_current, opts)
      vim.keymap.set("n", "<C-j>", M.move_current_down, opts)
      vim.keymap.set("n", "<C-k>", M.move_current_up, opts)
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
