return {
  {
    "nvim-mini/mini.diff",
    version = false,
    event = "BufRead",
    config = function(_, opts)
      vim.g.minidiff_disable = true

      require("mini.diff").setup({
        view = {
          style = "sign",
        },
      })

      vim.keymap.set("n", "<leader>ht", function()
        vim.g.minidiff_disable = not vim.g.minidiff_disable
        vim.cmd("edit")
      end, { desc = "Toggle mini.diff" })

      vim.keymap.set("n", "<leader>hp", function()
        MiniDiff.toggle_overlay()
      end, { desc = "Toggle mini.diff overlay" })
    end,
  },
}
