local env = require("conf.env")

return {
  { "olexsmir/gopher.nvim" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- go = { "golangcilint" },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofumpt" },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        go = function()
          return require("neotest-go")({
            experimental = {
              test_table = true,
            },
            -- args = { "-count=1", "-timeout=60s" },
          })
        end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    opts = {
      adapters = {
        go = {
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        },
      },
      configurations = {
        go = {
          {
            type = "go",
            name = "Debug (file)",
            request = "launch",
            program = "${file}",
          },
          -- configuration for debugging test files
          {
            type = "go",
            name = "Debug test (file)",
            request = "launch",
            mode = "test",
            program = "${file}",
          },
          -- works with go.mod packages and sub packages
          {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
          },
          {
            type = "go",
            name = "Debug test w/ args (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
            args = function()
              return coroutine.create(function(co)
                local default = _G.__go_dlv_last_args or "-test.run=TestXXX"
                vim.ui.input({ prompt = "dlv args:", default = default }, function(args)
                  _G.__go_dlv_last_args = args
                  coroutine.resume(co, vim.split(_G.__go_dlv_last_args, " "))
                end)
              end)
            end,
          },
        },
      },
    },
  },
}
