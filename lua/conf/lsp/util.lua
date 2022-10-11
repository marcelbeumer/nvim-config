local M = {}

M.find_root_dir = function(patterns, from_file)
  local opts = { upward = true, path = from_file }
  local root_dir = vim.fs.dirname(vim.fs.find(patterns, opts)[1])
  if root_dir then
    return vim.loop.fs_realpath(root_dir)
  end
end

M.disable_formatting = function(lsp_client)
  lsp_client.server_capabilities.documentFormattingProvider = false
  lsp_client.server_capabilities.documentRangeFormattingProvider = false
end

M.get_handlers = function()
  return {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" }),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "solid" }),
  }
end

M.get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Our autocomplete plugin will update the default LSP capabilities
  -- options normally passed to the LSP servers.
  require("cmp_nvim_lsp").update_capabilities(capabilities)
  return capabilities
end

return M