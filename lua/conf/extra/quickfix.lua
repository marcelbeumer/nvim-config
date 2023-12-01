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
end

return M
