local M = {}

M.setup = function()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    winbar = {
      enabled = true,
    },
  })

  local direction = "horizontal"
  local toggle_direction = function()
    if direction == "horizontal" then
      direction = "vertical"
    else
      direction = "horizontal"
    end
    print("toggleterm direction is now " .. direction)
  end

  vim.keymap.set("n", "<leader>0", function() end, { desc = "Terminal (all)" })
  vim.keymap.set("n", "<leader>0t", ":ToggleTermToggleAll<cr>", { silent = true, desc = "Toggle all toggleterms" })
  vim.keymap.set("n", "<leader>0r", ":ToggleTermSetName ", { desc = "Set toggleterm name" })
  vim.keymap.set("n", "<leader>0d", toggle_direction, { desc = "Toggle terminal direction" })

  local nums = { 1, 2, 3, 7, 8, 9 }
  for _, num in ipairs(nums) do
    vim.keymap.set({ "n", "t" }, "<leader>" .. num, function()
      vim.cmd(num .. "ToggleTerm direction=" .. direction)
    end, { silent = true, desc = "Toggle terminal " .. num })
  end
end

return M
