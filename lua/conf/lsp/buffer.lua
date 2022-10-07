local M = {}

-- on_attach configures the lsp client for a specific buffer.
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local get_buf_opts = function(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end

  -- Buffer specific mappings.
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, get_buf_opts("LSP goto declaration"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, get_buf_opts("LSP goto definition"))
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, get_buf_opts("LSP goto type definition"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, get_buf_opts("LSP show hover"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, get_buf_opts("LSP goto implementation"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, get_buf_opts("LSP signature help"))
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, get_buf_opts("LSP add workspace folder"))
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, get_buf_opts("LSP remove workspace folder"))
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, get_buf_opts("LSP list workspace folders"))
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, get_buf_opts("LSP rename"))
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, get_buf_opts("LSP code actions"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, get_buf_opts("LSP goto references"))
  vim.keymap.set("n", "<space>f", vim.lsp.buf.format, get_buf_opts("LSP formatting"))

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
  if client.supports_method("textDocument/formatting") then
    local fmt = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    vim.api.nvim_clear_autocmds({ group = fmt, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = fmt,
      buffer = bufnr,
      callback = function()
        if require("conf.env").NVIM_LSP_AUTO_FORMAT == "on" then
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      end,
    })
  end
end

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

return M
