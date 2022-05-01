local M = {}

M.flags = { debounce_text_changes = 300 }

M.on_attach = function(lsp_client, bufnr)
  local env = require("conf.env")

  -- Setup omnicomplete (nice to have on the side)
  vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

  local function bufmap(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
  end

  -- Built-in lsp
  bufmap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
  bufmap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  bufmap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
  bufmap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  bufmap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  bufmap("i", "<C-y>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  bufmap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
  bufmap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
  bufmap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
  bufmap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  bufmap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  bufmap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
  bufmap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  bufmap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
  bufmap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
  -- Goto-preview
  bufmap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
  bufmap("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
  bufmap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>")

  if lsp_client.resolved_capabilities.document_formatting then
    bufmap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")

    if env.NVIM_LSP_AUTO_FORMAT == "on" then
      vim.cmd([[
        augroup lsp_buffer_formatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]])
    end
  end

  if lsp_client.resolved_capabilities.document_range_formatting then
    bufmap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
  end

  if lsp_client.resolved_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_buffer_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end
end

M.disable_formatting = function(lsp_client)
  lsp_client.resolved_capabilities.document_formatting = false
  lsp_client.resolved_capabilities.document_range_formatting = false
end

M.config = function(config)
  local base = {
    flags = M.flags,
    capabilities = require("conf.plugins.cmp").get_lsp_capabilities(),
    on_attach = M.on_attach,
  }
  return vim.tbl_deep_extend("force", {}, base, config or {})
end

M.config_no_formatting = function(config)
  local base = M.config()
  local without = {
    on_attach = function(lsp_client, bufnr)
      M.disable_formatting(lsp_client)
      base.on_attach(lsp_client, bufnr)
    end,
  }
  return vim.tbl_deep_extend("force", {}, base, without, config or {})
end

return M
