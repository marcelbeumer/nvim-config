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

local lsp_window_opts = {
  border = "rounded",
}

local function hover_handler(err, result, ctx, config)
  local final_config = vim.tbl_deep_extend("force", config or {}, lsp_window_opts)
  local buf_id, win_id = vim.lsp.handlers.hover(err, result, ctx, final_config)
  vim.api.nvim_win_set_option(win_id, "linebreak", true)
  vim.api.nvim_win_set_option(win_id, "showbreak", "NONE")
  return buf_id, win_id
end

M.get_handlers = function()
  return {
    ["textDocument/hover"] = hover_handler,
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp_window_opts),
  }
end

M.get_capabilities = function()
  return require("cmp_nvim_lsp").default_capabilities()
end

return M
