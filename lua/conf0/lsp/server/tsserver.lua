local util = require("conf0.lsp.util")

local M = {}

M.setup = function()
  require("typescript/config").setupConfig({})

  vim.api.nvim_create_autocmd("FileType", {
    pattern = table.concat({
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    }, ","),
    callback = function(data)
      vim.lsp.start({
        name = "tsserver",
        cmd = { "typescript-language-server", "--stdio" },
        root_dir = util.find_root_dir({ ".git" }, data.file) or util.find_root_dir({
          "package.json",
          "tsconfig.json",
          "jsconfig.json",
        }, data.file) or vim.fn.getcwd(),
        init_options = { hostInfo = "neovim" },
        handlers = vim.tbl_extend("force", util.get_handlers(), {
          ["_typescript.rename"] = require("typescript/handlers").renameHandler,
        }),
        capabilities = util.get_capabilities(),
        on_init = function(client, _)
          client.notify("workspace/didChangeConfiguration", {
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
          })
        end,
        on_attach = function(client, bufnr)
          util.disable_formatting(client)

          if not require("typescript/config").config.disable_commands then
            require("typescript/commands").setupCommands(bufnr)
          end
        end,
      })
    end,
  })
end

return M
