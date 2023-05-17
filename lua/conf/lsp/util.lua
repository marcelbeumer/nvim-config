local M = {}

M.format_buffer = function(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if ft == "go" then
    require("conf.lsp.server.gopls").organize_imports_sync()
  end

  vim.lsp.buf.format({ bufnr = bufnr })
end

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

-- based on https://github.com/ray-x/go.nvim/blob/b119217e8324f13a2be12935f5d2d15a1df09b09/lua/go/lsp.lua
M.codeaction_sync = function(client, action, only, wait_ms)
  wait_ms = wait_ms or 1000

  local params = vim.lsp.util.make_range_params()
  if only then
    params.context = { only = { only } }
  end

  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  if not result or next(result) == nil then
    return
  end

  for _, res in pairs(result) do
    for _, r in pairs(res.result or {}) do
      if r.edit and not vim.tbl_isempty(r.edit) then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      end
      if type(r.command) == "table" then
        if type(r.command) == "table" and r.command.arguments then
          for _, arg in pairs(r.command.arguments) do
            if action == nil or arg["Fix"] == action then
              vim.lsp.buf.execute_command(r.command)
              return
            end
          end
        end
      end
    end
  end
end

return M
