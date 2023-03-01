local M = {}

M.setup = function()
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { silent = true }

  require("harpoon").setup({
    menu = {
      width = 120,
      height = 20,
    },
  })

  local with_redraw = function(fn)
    return function()
      fn()
      vim.cmd("redrawtabline")
    end
  end

  bind_all("harpoon.next", require("harpoon.ui").nav_next, {}, key_opts)
  bind_all("harpoon.prev", require("harpoon.ui").nav_prev, {}, key_opts)
  bind_all("harpoon.quick_menu", require("harpoon.ui").toggle_quick_menu, {}, key_opts)
  bind_all("harpoon.add", with_redraw(require("harpoon.mark").add_file), {}, key_opts)
  bind_all("harpoon.remove", with_redraw(require("harpoon.mark").rm_file), {}, key_opts)

  for num = 1, 9 do
    vim.keymap.set({ "n", "t" }, "<leader>" .. num, function()
      require("harpoon.term").gotoTerminal(num)
    end, { silent = true, desc = "Harpoon goto terminal " .. num })
  end
end

return M
