local M = {}

local sort_pos_asc = function(a, b)
  if a.lnum == b.lnum then
    return a.col < b.col
  elseif a.lnum < b.lnum then
    return true
  else
    return false
  end
end

local sort_pos_desc = function(a, b)
  if a.lnum == b.lnum then
    return a.col > b.col
  elseif a.lnum > b.lnum then
    return true
  else
    return false
  end
end

M.next_reference = function(reverse)
  local on_list = function(args)
    local fname = vim.api.nvim_buf_get_name(0)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local curr_pos = { lnum = cursor_pos[1], col = cursor_pos[2] + 1 }

    local items = vim.tbl_extend("keep", {}, args.items)
    table.sort(items, sort_pos_asc)

    local positions = {}
    for _, item in pairs(args.items) do
      if item.filename == fname then
        local idx = #positions + 1
        positions[idx] = { idx = idx, lnum = item.lnum, col = item.col }
      end
    end

    if #positions == 0 then
      print("LSP reference [0/0]")
      return
    end

    if reverse then
      table.sort(positions, sort_pos_desc)
    end

    local target = positions[1]
    local is_next = reverse and sort_pos_desc or sort_pos_asc
    for _, pos in pairs(positions) do
      if is_next(curr_pos, pos) then
        target = pos
        break
      end
    end

    print("LSP reference [" .. target.idx .. "/" .. #positions .. "]")
    vim.fn.setpos(".", { 0, target.lnum, target.col })
  end

  vim.lsp.buf.references(nil, { on_list = on_list })
end

M.organize_imports = function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports" },
    },
    apply = true,
  })
end

return M
