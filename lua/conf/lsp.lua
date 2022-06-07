local M = {}

local disable_formatting = function(lsp_client)
  lsp_client.server_capabilities.documentFormattingProvider = false
  lsp_client.server_capabilities.documentRangeFormattingProvider = false
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)

  local env = require("conf.env")
  if env.NVIM_LSP_AUTO_FORMAT == "on" and client.supports_method("textDocument/formatting") then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

M.setup = function()
  local env = require("conf.env")
  local lspconfig = require("lspconfig")
  local capabilities = require("conf.plugins").make_lsp_capabilities()

  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    severity_sort = true,
  })

  local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

  local null_ls = require("null-ls")
  local staticcheck = require("conf.staticcheck")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.golines,
      staticcheck,
    },
    capabilities = capabilities,
    on_attach = on_attach,
  })

  if env.NVIM_TS_LSP == "tsserver" then
    lspconfig.tsserver.setup({
      -- init_options = {
      -- 	preferences = {
      -- 	  importModuleSpecifierEnding = "js",
      -- 	},
      -- },
      capabilities = capabilities,
      on_attach = function(lsp_client, bufnr)
        disable_formatting(lsp_client)
        local lsp_ts_utils = require("nvim-lsp-ts-utils")
        lsp_ts_utils.setup({
          eslint_enable_code_actions = false,
          update_imports_on_move = true,
          require_confirmation_on_move = true,
        })
        lsp_ts_utils.setup_client(lsp_client)
        vim.api.nvim_create_user_command("OrganizeImports", "TSLspOrganize", {})
        on_attach(lsp_client, bufnr)
      end,
    })
  elseif env.NVIM_TS_LSP == "volar" then
    lspconfig.volar.setup({
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
      },
      capabilities = capabilities,
      on_attach = function(lsp_client, bufnr)
        disable_formatting(lsp_client)
        on_attach(lsp_client, bufnr)
      end,
    })
  end

  lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = function(lsp_client, bufnr)
      disable_formatting(lsp_client)
      on_attach(lsp_client, bufnr)
    end,
  })

  local luadev = require("lua-dev").setup({
    lspconfig = {
      cmd = { "lua-language-server" },
    },
    capabilities = capabilities,
    on_attach = function(lsp_client, bufnr)
      disable_formatting(lsp_client)
      on_attach(lsp_client, bufnr)
    end,
  })
  lspconfig.sumneko_lua.setup(luadev)

  lspconfig.clangd.setup({
    capabilities = capabilities,
    on_attach = function(lsp_client, bufnr)
      disable_formatting(lsp_client)
      on_attach(lsp_client, bufnr)
    end,
  })
end

return M
