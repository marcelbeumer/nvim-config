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
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local buf_opts = function(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end

  -- Buffer specific mappings.
  vim.keymap.set("n", "<M-n>", function()
    next_reference()
  end, buf_opts("Next LSP reference"))
  vim.keymap.set("n", "<M-N>", function()
    next_reference(true)
  end, buf_opts("Prev LSP reference"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts("LSP goto declaration"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts("LSP goto definition"))
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, buf_opts("LSP goto type definition"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts("LSP show hover"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts("LSP goto implementation"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, buf_opts("LSP signature help"))
  vim.keymap.set("i", "<C-y>", vim.lsp.buf.signature_help, buf_opts("LSP signature help"))
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, buf_opts("LSP add workspace folder"))
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, buf_opts("LSP remove workspace folder"))
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, buf_opts("LSP list workspace folders"))
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, buf_opts("LSP rename"))
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, buf_opts("LSP code actions"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts("LSP goto references"))
  vim.keymap.set("n", "<space>f", vim.lsp.buf.format, buf_opts("LSP formatting"))

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

    vim.keymap.set("n", "<space>h", toggle, buf_opts("LSP highlight"))
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
