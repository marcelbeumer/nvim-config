return {
  {
    "olimorris/codecompanion.nvim",
    version = "v17.33.0",
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
          -- model = "claude-sonnet-4-20250514",
        },
        inline = {
          adapter = "anthropic",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
