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

  -- local target_types = {
  --   ["var_declaration"] = true,
  --   ["type_declaration"] = true,
  --   ["import_declaration"] = true,
  --   ["const_declaration"] = true,
  --   ["select_statement"] = true,
  --   ["expression_switch_statement"] = true,
  --   ["expression_case"] = true,
  --   ["short_var_declaration"] = true,
  --   ["default_case"] = true,
  --   ["block"] = true,
  --   ["func_literal"] = true,
  --   ["literal_element"] = true,
  -- }
  local parent = node:parent()
  while parent do
    local start_row, _, _ = parent:start()
    print(parent:type())
    -- if target_types[parent:type()] and start_row < current_row then
    if start_row < current_row then
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
      return
    end
    parent = parent:parent()
  end
end

M.jump_to_less_indented_line = function()
  local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
  local current_indent = vim.fn.indent(current_line_num)

  for line_num = current_line_num - 1, 1, -1 do
    local line_content = tostring(vim.fn.getline(line_num))
    if line_content:match("%S") and vim.fn.indent(line_num) < current_indent then
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_cursor(0, { line_num, 0 })
      break
    end
  end
end

return M
