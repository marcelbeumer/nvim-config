local util = require("conf.lsp.util")

local M = {}

local sort_pos_asc = function(a, b)
  if a.lnum == b.lnum then
    return a.col < b.col
  elseif a.lnum < b.lnum then
    return true
  else
    return false
  end
end

local sort_pos_desc = function(a, b)
  if a.lnum == b.lnum then
    return a.col > b.col
  elseif a.lnum > b.lnum then
    return true
  else
    return false
  end
end

local next_reference = function(reverse)
  local on_list = function(args)
    local uri = args.context.params.textDocument.uri
    local fname = vim.uri_to_fname(uri)
    local position = args.context.params.position
    local curr_pos = { lnum = position.line + 1, col = position.character + 1 }

    local items = vim.tbl_extend("keep", {}, args.items)
    table.sort(items, sort_pos_asc)

    local positions = {}
    for _, item in pairs(args.items) do
      if item.filename == fname then
        local idx = #positions + 1
        positions[idx] = { idx = idx, lnum = item.lnum, col = item.col }
      end
    end

    if #positions == 0 then
      print("LSP reference [0/0]")
      return
    end

    if reverse then
      table.sort(positions, sort_pos_desc)
    end

    local target = positions[1]
    local is_next = reverse and sort_pos_desc or sort_pos_asc
    for _, pos in pairs(positions) do
      if is_next(curr_pos, pos) then
        target = pos
        break
      end
    end

    print("LSP reference [" .. target.idx .. "/" .. #positions .. "]")
    vim.fn.setpos(".", { 0, target.lnum, target.col })
  end

  vim.lsp.buf.references(nil, { on_list = on_list })
end

-- on_attach configures the lsp client for a specific buffer.
local on_attach = function(client, bufnr)
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true, buffer = bufnr }

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Enable enhanced signature help.
  -- local signature = require("lsp_signature")
  -- signature.on_attach({ hint_enable = false, doc_lines = 0 }, bufnr)
  -- bind_all("lsp.signature_help", signature.toggle_float_win, {}, key_opts)
  bind_all("lsp.signature_help", vim.lsp.buf.signature_help, {}, key_opts)

  -- Buffer specific bindings.
  bind_all("lsp.next_reference", function()
    next_reference()
  end, {}, key_opts)
  bind_all("lsp.prev_reference", function()
    next_reference(true)
  end, {}, key_opts)

  bind_all("lsp.goto_definition", vim.lsp.buf.definition, {}, key_opts)
  bind_all("lsp.goto_declaration", vim.lsp.buf.declaration, {}, key_opts)
  bind_all("lsp.goto_references", vim.lsp.buf.references, {}, key_opts)
  bind_all("lsp.goto_implementation", vim.lsp.buf.implementation, {}, key_opts)
  bind_all("lsp.goto_typedef", vim.lsp.buf.type_definition, {}, key_opts)
  bind_all("lsp.hover", vim.lsp.buf.hover, {}, key_opts)
  bind_all("lsp.rename", vim.lsp.buf.rename, {}, key_opts)
  bind_all("lsp.code_actions", vim.lsp.buf.code_action, {}, key_opts)
  bind_all("lsp.format", vim.lsp.buf.format, {}, key_opts)
  bind_all("lsp.add_workspace_folder", vim.lsp.buf.add_workspace_folder, {}, key_opts)
  bind_all("lsp.remove_workspace_folder", vim.lsp.buf.remove_workspace_folder, {}, key_opts)
  bind_all("lsp.list_workspace_folders", vim.lsp.buf.list_workspace_folders, {}, key_opts)

  -- Highlight symbol under cursor.
  if client.supports_method("textDocument/documentHighlight") then
    local hl = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
    local opts = { group = hl, buffer = bufnr }
    vim.api.nvim_clear_autocmds(opts)

    local enabled = false
    local update = function()
      if enabled then
        vim.lsp.buf.document_highlight()
      else
        vim.lsp.buf.clear_references()
      end
    end
    local clear = function()
      if enabled then
        vim.lsp.buf.clear_references()
      end
    end
    local toggle = function()
      enabled = not enabled
      update()
    end

    bind_all("lsp.toggle_highlight", toggle, {}, key_opts)

    vim.api.nvim_create_autocmd("CursorHold", { group = hl, buffer = bufnr, callback = update })
    vim.api.nvim_create_autocmd("CursorHoldI", { group = hl, buffer = bufnr, callback = update })
    vim.api.nvim_create_autocmd("CursorMoved", { group = hl, buffer = bufnr, callback = clear })
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
          util.format_buffer(bufnr)
        end
      end,
    })
  end
end

local disable_lsp_semantic_highlighting = function()
  -- based on :help lsp-semantic-highlight
  vim.api.nvim_set_hl(0, "@lsp.type.function", {})
  for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
    vim.api.nvim_set_hl(0, group, {})
  end
end

M.setup = function()
  disable_lsp_semantic_highlighting()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = disable_lsp_semantic_highlighting,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

return M
