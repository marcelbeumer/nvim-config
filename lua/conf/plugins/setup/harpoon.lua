local M = {}

M.setup = function()
  require("harpoon").setup({
    menu = {
      width = 120,
      height = 20,
    },
  })

  local get_opts = function(desc)
    return { desc = desc }
  end

  vim.keymap.set("n", "<space>a", require("harpoon.mark").add_file, get_opts("Harpoon add file"))
  vim.keymap.set("n", "<space>d", require("harpoon.mark").rm_file, get_opts("Harpoon remove file"))
  vim.keymap.set("n", "<space>p", require("harpoon.ui").toggle_quick_menu, get_opts("Harpoon quick menu"))

  vim.keymap.set("n", "<C-,>", require("harpoon.ui").nav_prev, { silent = true })
  vim.keymap.set("n", "<C-.>", require("harpoon.ui").nav_next, { silent = true })

  for num = 1, 9 do
    vim.keymap.set({ "n", "t" }, "<leader>" .. num, function()
      require("harpoon.term").gotoTerminal(num)
    end, { silent = true, desc = "Harpoon goto terminal " .. num })
  end
end

return M
