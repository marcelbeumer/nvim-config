return {
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("mini.pairs").setup(opts)
      vim.api.nvim_create_user_command("AutopairsToggle", function()
        vim.g.minipairs_disable = not vim.g.minipairs_disable
        if vim.g.minipairs_disable then
          vim.notify("Disabled autopairs")
        else
          vim.notify("Enabled autopairs")
        end
      end, {})
    end,
  },
}
