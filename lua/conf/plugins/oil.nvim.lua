return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      columns = {
        -- "permissions",
        -- "size",
        -- "mtime",
      },
    },
  },
}
