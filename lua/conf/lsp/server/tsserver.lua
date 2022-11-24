local util = require("conf.lsp.util")

local M = {}

M.setup = function()
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
        handlers = util.get_handlers(),
        capabilities = util.get_capabilities(),
        on_attach = function(client)
          util.disable_formatting(client)
          -- Add some extra LSP features on top of what the server provides.
          local lsp_ts_utils = require("nvim-lsp-ts-utils")
          lsp_ts_utils.setup({
            eslint_enable_code_actions = false,
            update_imports_on_move = true,
            require_confirmation_on_move = true,
          })
          lsp_ts_utils.setup_client(client)
          vim.api.nvim_create_user_command("OrganizeImports", "TSLspOrganize", {})
        end,
      })
    end,
  })
end

return M
