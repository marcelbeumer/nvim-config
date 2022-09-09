local M = {}

-- disable_formatting disables lsp client formatting capabilities.
-- This is used for many LSP servers as most often we do formatting with
-- the null-ls LSP server separately.
local disable_formatting = function(lsp_client)
  lsp_client.server_capabilities.documentFormattingProvider = false
  lsp_client.server_capabilities.documentRangeFormattingProvider = false
end

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "solid" }),
}

-- on_attach configures the lsp client for a specific buffer.
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Buffer specific mappings.
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
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

  -- Highlight symbol under cursor.
  if client.supports_method("textDocument/documentHighlight") then
    local hl = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
    local opts = { group = hl, buffer = bufnr }
    vim.api.nvim_clear_autocmds(opts)

    vim.api.nvim_create_autocmd("CursorHold", {
      group = hl,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorHoldI", {
      group = hl,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = hl,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Format on save.
  local env = require("conf.env")
  if env.NVIM_LSP_AUTO_FORMAT == "on" and client.supports_method("textDocument/formatting") then
    local fmt = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ group = fmt, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = fmt,
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
  -- Our autocomplete plugin will update the default LSP capabilities
  -- options normally passed to the LSP servers.
  local capabilities = require("conf.plugins").make_lsp_capabilities()

  vim.diagnostic.config({
    -- Virtual text is too noisy IMO. Downside is that you have to manually
    -- trigger showing diagnostics (with K on a specific line).
    virtual_text = false,
    -- Without noisy virtual text it's ok to update in insert mode.
    update_in_insert = true,
    -- Put errors on top.
    severity_sort = true,
  })

  -- Configure prettier gutter diagnostic signs.
  local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
  -- local signs = { Hint = "", Info = "", Warn = "", Error = "" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  -- Global mappings.
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

  -- We use null-ls for most formatting and linting.
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.terraform_fmt,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.goimports,
      -- null_ls.builtins.formatting.golines.with({
      --   extra_args = { "-m", "80" },
      -- }),
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.diagnostics.staticcheck.with({
        cwd = function(params)
          return vim.fn.getcwd()
        end,
        diagnostics_postprocess = function(diagnostic)
          if diagnostic.severity == vim.diagnostic.severity["ERROR"] then
            diagnostic.severity = vim.diagnostic.severity["WARN"]
          end
        end,
      }),
    },
    capabilities = capabilities,
    on_attach = on_attach,
    handlers = handlers,
  })

  -- Different LSP severs for TypeScript.
  if env.NVIM_TS_LSP == "tsserver" then
    lspconfig.tsserver.setup({
      -- Uncomment for ES module auto-imports with file extensions.
      -- init_options = {
      -- 	preferences = {
      -- 	  importModuleSpecifierEnding = "js",
      -- 	},
      -- },
      handlers = handlers,
      capabilities = capabilities,
      on_attach = function(lsp_client, bufnr)
        disable_formatting(lsp_client)
        -- Add some extra LSP features on top of what the server provides.
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
    handlers = handlers,
    on_attach = function(lsp_client, bufnr)
      disable_formatting(lsp_client)
      on_attach(lsp_client, bufnr)
    end,
  })

  lspconfig.clangd.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = function(lsp_client, bufnr)
      on_attach(lsp_client, bufnr)
    end,
  })

  lspconfig.terraformls.setup({
    capabilities = capabilities,
    handlers = handlers,
    on_attach = function(lsp_client, bufnr)
      on_attach(lsp_client, bufnr)
    end,
  })

  local luadev = require("lua-dev").setup({})
  lspconfig.sumneko_lua.setup(luadev)
end

return M
