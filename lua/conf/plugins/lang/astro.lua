return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = function()
          if require("conf.env").NVIM_TS_LSP ~= "astro" then
            return
          end

          return {
            filetypes = {
              "typescript",
              "javascript",
              "javascriptreact",
              "typescriptreact",
              "astro",
              "json",
            },
          }
        end,
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        astro = { { "prettierd", "prettier" } },
      },
    },
  },
}
