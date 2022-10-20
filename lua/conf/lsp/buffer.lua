local M = {}

local goto_reference = function(is_next)
  local function on_list(args)
    local uri = args.context.params.textDocument.uri
    local fname = vim.uri_to_fname(uri)
    local position = args.context.params.position
    local curr_pos = { lnum = position.line + 1, col = position.character + 1 }

    local positions = {}
    for _, item in pairs(args.items) do
      if item.filename == fname then
        positions[#positions + 1] = { lnum = item.lnum, col = item.col }
      end
    end

    if #positions == 0 then
      print("LSP reference [0/0]")
      return
    end

    table.sort(positions, is_next)

    local pos_idx = 1
    for idx, pos in pairs(positions) do
      if is_next(curr_pos, pos) then
        pos_idx = idx
        break
      end
    end

    print("LSP reference [" .. pos_idx .. "/" .. #positions .. "]")
    local pos = positions[pos_idx]
    vim.fn.setpos(".", { 0, pos.lnum, pos.col })
  end

  vim.lsp.buf.references(nil, { on_list = on_list })
end

local next_reference = function()
  goto_reference(function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    elseif a.lnum < b.lnum then
      return true
    else
      return false
    end
  end)
end

local prev_reference = function()
  goto_reference(function(a, b)
    if a.lnum == b.lnum then
      return a.col > b.col
    elseif a.lnum > b.lnum then
      return true
    else
      return false
    end
  end)
end

-- on_attach configures the lsp client for a specific buffer.
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local nbuf_opts = function(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end

  -- Buffer specific mappings.
  vim.keymap.set("n", "<M-n>", next_reference, nbuf_opts("Next LSP reference"))
  vim.keymap.set("n", "<M-N>", prev_reference, nbuf_opts("Prev LSP reference"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, nbuf_opts("LSP goto declaration"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, nbuf_opts("LSP goto definition"))
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, nbuf_opts("LSP goto type definition"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, nbuf_opts("LSP show hover"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, nbuf_opts("LSP goto implementation"))
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, nbuf_opts("LSP signature help"))
  vim.keymap.set("i", "<C-y>", vim.lsp.buf.signature_help, nbuf_opts("LSP signature help"))
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, nbuf_opts("LSP add workspace folder"))
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, nbuf_opts("LSP remove workspace folder"))
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, nbuf_opts("LSP list workspace folders"))
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, nbuf_opts("LSP rename"))
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, nbuf_opts("LSP code actions"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, nbuf_opts("LSP goto references"))
  vim.keymap.set("n", "<space>f", vim.lsp.buf.format, nbuf_opts("LSP formatting"))

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
