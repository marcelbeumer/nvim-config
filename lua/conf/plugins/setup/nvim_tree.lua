local M = {}

M.setup = function()
  require("nvim-tree").setup({
    view = {
      adaptive_size = true,
      mappings = {
        list = {
          { key = "[d", action = "prev_diag_item" },
          { key = "]d", action = "next_diag_item" },
        },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = { error = "●", warning = "●", hint = "●", info = "●" },
    },
    live_filter = {
      always_show_folders = false,
    },
    renderer = {
      icons = {
        show = {
          folder = false,
          file = false,
        },
      },
    },
  })

  local print_cwd = function()
    print("cwd is now: " .. vim.fn.getcwd())
  end

  vim.api.nvim_create_user_command("NvimTreePullCwd", function()
    local cwd = require("nvim-tree.core").get_cwd()
    vim.cmd("cd " .. vim.fn.fnameescape(cwd))
    print_cwd()
  end, {})

  vim.api.nvim_create_user_command("NvimTreePushCwd", function()
    require("nvim-tree.api").tree.change_root(vim.fn.getcwd())
    print_cwd()
  end, {})

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>;", ":NvimTreeToggle<cr>", opts)
  vim.keymap.set("n", "<leader>'", ":NvimTreeFindFile<cr>", opts)
  vim.keymap.set("n", "<leader>,", ":NvimTreePullCwd<cr>", opts)
  vim.keymap.set("n", "<leader>.", ":NvimTreePushCwd<cr>", opts)
end

return M
