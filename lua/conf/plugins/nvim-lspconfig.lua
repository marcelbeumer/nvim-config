local env = require("conf.env")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "yioneko/nvim-vtsls", -- vtsls, typescript
    },
    opts = {
      servers = {
        lua_ls = {},
        gopls = {
          init_options = {
            buildFlags = { "-tags=integration" },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
          settings = {
            gopls = {
              ["local"] = env.NVIM_GOPLS_LOCAL,
            },
          },
        },
        pylsp = {},
        terraformls = {},
        vtsls = function()
          if require("conf.env").NVIM_TS_LSP == "vtsls" then
            return {}
          end
        end,
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

    config = function(_, opts)
      if require("conf.env").NVIM_LSP == "off" then
        return
      end

      local lspconfig = require("lspconfig")
      local util = require("conf.lsp")
      local map = vim.keymap.set

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end

          local opts = { buffer = args.buf }
          map("n", "grt", vim.lsp.buf.type_definition, opts)
          map("n", "grh", vim.lsp.buf.document_highlight, opts)
          map("n", "grc", vim.lsp.buf.clear_references, opts)
          map("n", "<space>I", util.organize_imports)
          map("n", "<space>H", function()
            local enabled = not vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(enabled)
          end, opts)

          map("n", "[r", function()
            util.next_reference(true)
          end, opts)
          map("n", "]r", function()
            util.next_reference()
          end, opts)
        end,
      })

      for name, conf in pairs(opts.servers) do
        if type(conf) == "function" then
          local result = conf()
          if result then
            lspconfig[name].setup(result)
          end
        else
          lspconfig[name].setup(conf)
        end
      end
    end,
  },
}
