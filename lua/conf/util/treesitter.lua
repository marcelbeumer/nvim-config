local M = {}

M.jump_to_parent_node = function()
  local parsers = require("nvim-treesitter.parsers")
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = parsers.get_parser(bufnr)
  if not parser then
    return
  end

  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()
  if not root then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_row, current_col = cursor[1] - 1, cursor[2]

  local node = root:named_descendant_for_range(current_row, current_col, current_row, current_col)
  if not node then
    return
  end

  local parent = node:parent()
  while parent do
    local start_row, _, _ = parent:start()
    if start_row < current_row then
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
      return
    end
    parent = parent:parent()
  end
end

return M
