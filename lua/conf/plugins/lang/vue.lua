return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = function()
          if require("conf.env").NVIM_TS_LSP ~= "volar" then
            return
          end

          return {
            filetypes = {
              "typescript",
              "javascript",
              "javascriptreact",
              "typescriptreact",
              "vue",
              "json",
            },
            init_options = {
              typescript = {
                tsdk = vim.env.HOME .. "/dev/node_modules/typescript/lib",
              },
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
        vue = { { "prettierd", "prettier" } },
      },
    },
  },
}
