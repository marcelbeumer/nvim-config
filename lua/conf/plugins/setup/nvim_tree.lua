local M = {}

M.tree_cwd = function()
  return require("nvim-tree.core").get_cwd()
end

M.set_tree_cwd = function(cwd)
  require("nvim-tree.api").tree.change_root(cwd)
end

M.setup = function()
  local bindings = require("conf.bindings")
  local keys = bindings.config.tree
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local use_float = false

  local setup_nvim_tree = function()
    require("nvim-tree").setup({
      view = {
        float = {
          enable = use_float,
          open_win_config = {
            border = "shadow",
          },
        },
        preserve_window_proportions = true,
        adaptive_size = true,
        mappings = {
          list = {
            { key = keys.prev_diag.value, action = "prev_diag_item" },
            { key = keys.next_diag.value, action = "next_diag_item" },
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
  end

  bind_all("tree.toggle", ":NvimTreeToggle<cr>", {}, key_opts)
  bind_all("tree.find_file", ":NvimTreeFindFile<cr>", {}, key_opts)
  bind_all("tree.toggle_float", function()
    use_float = not use_float
    vim.notify("nvim tree use float: " .. tostring(use_float))
    setup_nvim_tree()
  end, {}, key_opts)

  setup_nvim_tree()
end

return M
