local M = {}

local function jump_to_less_indented_line()
  local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
  local current_indent = vim.fn.indent(current_line_num)

  for line_num = current_line_num - 1, 1, -1 do
    local line_content = tostring(vim.fn.getline(line_num))
    local indent = vim.fn.indent(line_num)
    if line_content:match("%S") and indent < current_indent then
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_cursor(0, { line_num, 0 })
      if indent > 0 then
        vim.cmd("normal! w")
      end
      vim.cmd("normal! m'")
      break
    end
  end
end

M.setup = function()
  vim.keymap.set("n", "<leader>jp", jump_to_less_indented_line, {})
end

return M
