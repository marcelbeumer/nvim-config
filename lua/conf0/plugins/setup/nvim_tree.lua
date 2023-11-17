local M = {}

M.tree_cwd = function()
  return require("nvim-tree.core").get_cwd()
end

M.set_tree_cwd = function(cwd)
  require("nvim-tree.api").tree.change_root(cwd)
end

M.setup = function()
  local bindings = require("conf0.bindings")
  local keys = bindings.config.tree
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }

  require("nvim-tree").setup({
    view = {
      preserve_window_proportions = true,
      width = {
        min = 30,
        max = 120,
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
      indent_markers = {
        enable = true,
      },
      icons = {
        show = {
          folder = false,
          file = false,
        },
      },
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.set("n", keys.prev_diag.value, api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
      vim.keymap.set("n", keys.next_diag.value, api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    end,
  })

  bind_all("tree.toggle", ":NvimTreeToggle<cr>", {}, key_opts)
  bind_all("tree.find_file", ":NvimTreeFindFile<cr>", {}, key_opts)
end

return M
