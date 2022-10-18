local M = {}

M.tree_cwd = function()
  return require("nvim-tree.core").get_cwd()
end

M.set_tree_cwd = function(cwd)
  require("nvim-tree.api").tree.change_root(cwd)
end

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

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>;", ":NvimTreeToggle<cr>", opts)
  vim.keymap.set("n", "<leader>'", ":NvimTreeFindFile<cr>", opts)
  vim.keymap.set("n", "<leader>,", ":NvimTreePullCwd<cr>", opts)
  vim.keymap.set("n", "<leader>.", ":NvimTreePushCwd<cr>", opts)
end

return M
