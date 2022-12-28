local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { silent = true }
  local cmd_opts = {}

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

  bind_all("harpoon.next", require("harpoon.ui").nav_next, cmd_opts, key_opts)
  bind_all("harpoon.prev", require("harpoon.ui").nav_prev, cmd_opts, key_opts)
  bind_all("harpoon.quick_menu", require("harpoon.ui").toggle_quick_menu, cmd_opts, key_opts)
  bind_all("harpoon.add", with_redraw(require("harpoon.mark").add_file), cmd_opts, key_opts)
  bind_all("harpoon.remove", with_redraw(require("harpoon.mark").rm_file), cmd_opts, key_opts)

  for num = 1, 9 do
    vim.keymap.set({ "n", "t" }, "<leader>" .. num, function()
      require("harpoon.term").gotoTerminal(num)
    end, { silent = true, desc = "Harpoon goto terminal " .. num })
  end
end

return M
