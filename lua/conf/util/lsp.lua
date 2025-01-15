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

M.disable_lsp_semantic_highlighting = function()
  -- based on :help lsp-semantic-highlight
  vim.api.nvim_set_hl(0, "@lsp.type.function", {})
  for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
  end
end

-- based on https://github.com/ray-x/go.nvim/blob/b119217e8324f13a2be12935f5d2d15a1df09b09/lua/go/lsp.lua
M.codeaction_sync = function(client, action, only, wait_ms)
  wait_ms = wait_ms or 1000

  local params = vim.lsp.util.make_range_params()
  if only then
    params.context = { only = { only } }
  end

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  if not result or next(result) == nil then
    return
  end

  for _, res in pairs(result) do
    for _, r in pairs(res.result or {}) do
      if r.edit and not vim.tbl_isempty(r.edit) then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      end
      if type(r.command) == "table" and r.command.arguments then
        for _, arg in pairs(r.command.arguments) do
          if action == nil or arg["Fix"] == action then
            vim.lsp.buf.execute_command(r.command)
            return
          end
        end
      end
    end
  end
end

function M.client()
  local clients = vim.lsp.get_active_clients()
  for _, cl in pairs(clients) do
    if cl.name == "gopls" then
      return cl
    end
  end
end

M.organize_imports = function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports" },
    },
    apply = true,
  })
end

M.organize_imports_sync = function()
  local c = M.client()
  if not c then
    return
  end
  M.codeaction_sync(c, "", "source.organizeImports", 1000)
end

return M
