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
    start_in_insert = false,
    winbar = {
      enabled = true,
    },
    -- open_mapping = [[<c-\>]],
    --
  })

  vim.keymap.set("n", "<leader>0t", ":ToggleTermToggleAll<cr>", { silent = true })
  vim.keymap.set("n", "<leader>0r", ":ToggleTermSetName ", {})

  vim.keymap.set("n", "<leader>0", function() end, { desc = "Terminal (all)" })
  vim.keymap.set("n", "<leader>1", function() end, { desc = "Terminal 1" })
  vim.keymap.set("n", "<leader>2", function() end, { desc = "Terminal 2" })
  vim.keymap.set("n", "<leader>3", function() end, { desc = "Terminal 3" })
  vim.keymap.set("n", "<leader>7", function() end, { desc = "Terminal 7" })
  vim.keymap.set("n", "<leader>8", function() end, { desc = "Terminal 8" })
  vim.keymap.set("n", "<leader>9", function() end, { desc = "Terminal 9" })

  vim.keymap.set("n", "<leader>1x", ":1ToggleTerm<cr>", { silent = true })
  vim.keymap.set("n", "<leader>2x", ":2ToggleTerm<cr>", { silent = true })
  vim.keymap.set("n", "<leader>3x", ":3ToggleTerm<cr>", { silent = true })
  vim.keymap.set("n", "<leader>7x", ":7ToggleTerm<cr>", { silent = true })
  vim.keymap.set("n", "<leader>8x", ":8ToggleTerm<cr>", { silent = true })
  vim.keymap.set("n", "<leader>9x", ":9ToggleTerm<cr>", { silent = true })

  vim.keymap.set("n", "<leader>1h", ":1ToggleTerm direction=horizontal<cr>", { silent = true })
  vim.keymap.set("n", "<leader>2h", ":2ToggleTerm direction=horizontal<cr>", { silent = true })
  vim.keymap.set("n", "<leader>3h", ":3ToggleTerm direction=horizontal<cr>", { silent = true })
  vim.keymap.set("n", "<leader>7h", ":7ToggleTerm direction=horizontal<cr>", { silent = true })
  vim.keymap.set("n", "<leader>8h", ":8ToggleTerm direction=horizontal<cr>", { silent = true })
  vim.keymap.set("n", "<leader>9h", ":9ToggleTerm direction=horizontal<cr>", { silent = true })

  vim.keymap.set("n", "<leader>1v", ":1ToggleTerm direction=vertical<cr>", { silent = true })
  vim.keymap.set("n", "<leader>2v", ":2ToggleTerm direction=vertical<cr>", { silent = true })
  vim.keymap.set("n", "<leader>3v", ":3ToggleTerm direction=vertical<cr>", { silent = true })
  vim.keymap.set("n", "<leader>7v", ":7ToggleTerm direction=vertical<cr>", { silent = true })
  vim.keymap.set("n", "<leader>8v", ":8ToggleTerm direction=vertical<cr>", { silent = true })
  vim.keymap.set("n", "<leader>9v", ":9ToggleTerm direction=vertical<cr>", { silent = true })
end

return M
