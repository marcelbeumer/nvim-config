local M = {}

M.setup = function()
  local env = require("conf.env")
  local lspconfig = require("lspconfig")
  local staticcheck = require("conf.plugins.lsp.staticcheck")
  local config = require("conf.plugins.lsp.server_config")

  local null_ls = require("null-ls")
  null_ls.setup({
    debounce = config.flags.debounce_text_changes,
    sources = {
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.gofmt,
      -- null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.golines,
      staticcheck,
      null_ls.builtins.formatting.black,
      -- null_ls.builtins.diagnostics.pylint,
      null_ls.builtins.formatting.prettierd,
      -- null_ls.builtins.diagnostics.eslint_d,
    },
    on_attach = config.on_attach,
  })

  if env.NVIM_TS_LSP == "tsserver" then
    lspconfig.tsserver.setup(config.config({
      -- init_options = {
      -- 	preferences = {
      -- 	  importModuleSpecifierEnding = "js",
      -- 	},
      -- },
      on_attach = function(lsp_client, bufnr)
        config.disable_formatting(lsp_client)
        local lsp_ts_utils = require("nvim-lsp-ts-utils")
        lsp_ts_utils.setup({
          eslint_enable_code_actions = false,
          update_imports_on_move = true,
          require_confirmation_on_move = true,
        })
        lsp_ts_utils.setup_client(lsp_client)
        vim.cmd([[command! -buffer OrganizeImports TSLspOrganize]])
        config.on_attach(lsp_client, bufnr)
        -- vim.cmd("TSLspOrganizeSync")
        -- vim.lsp.buf.formatting_sync()
        -- vim.cmd("up")
        -- vim.defer_fn(function()
        --   vim.cmd("next")
        -- end, 100)
      end,
    }))
  elseif env.NVIM_TS_LSP == "volar" then
    lspconfig.volar.setup(config.config_no_formatting({
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
      },
    }))
  end

  lspconfig.gopls.setup(config.config_no_formatting())

  local luadev = require("lua-dev").setup({
    lspconfig = config.config_no_formatting({
      cmd = { "lua-language-server" },
    }),
  })
  lspconfig.sumneko_lua.setup(luadev)

  lspconfig.jedi_language_server.setup(config.config_no_formatting())

  lspconfig.yamlls.setup(config.config_no_formatting({
    settings = {
      yaml = {
        schemas = {
          -- ["https://json.schemastore.org/chart.json"] = "/chart/*",
          kubernetes = {
            "k8s/**/*.yml",
            "k8s/**/*.yaml",
          },
        },
      },
    },
  }))
end

return M
