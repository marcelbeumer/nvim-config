local M = {}

M.setup = function()
  local get_opts = function(desc)
    return { desc = desc }
  end
  vim.keymap.set("n", "<leader>h", function() end, get_opts("Harpoon..."))
  vim.keymap.set("n", "<space><space>", require("harpoon.ui").toggle_quick_menu, get_opts("Harpoon UI"))
  vim.keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu, get_opts("Harpoon UI"))
  vim.keymap.set("n", "<leader>ha", require("harpoon.mark").add_file, get_opts("Harpoon mark file"))
  -- vim.keymap.set("n", "<leader>hn", require("harpoon.ui").nav_next, get_opts("Harpoon goto next"))
  -- vim.keymap.set("n", "<leader>hp", require("harpoon.ui").nav_prev, get_opts("Harpoon goto previous"))
end

return M
