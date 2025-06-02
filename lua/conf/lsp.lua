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
    local fname = vim.api.nvim_buf_get_name(0)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local curr_pos = { lnum = cursor_pos[1], col = cursor_pos[2] + 1 }

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

local organize_imports = function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports" },
    },
    apply = true,
  })
end

M.setup = function()
  if require("conf.env").NVIM_LSP == "off" then
    return
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
        return
      end

      local opts = { buffer = args.buf }
      local map = vim.keymap.set

      map("n", "grt", vim.lsp.buf.type_definition, opts)
      map("n", "grh", vim.lsp.buf.document_highlight, opts)
      map("n", "grc", vim.lsp.buf.clear_references, opts)
      map("n", "<space>I", organize_imports)
      map("n", "<space>H", function()
        local enabled = not vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(enabled)
      end, opts)

      map("n", "[r", function()
        next_reference(true)
      end, opts)
      map("n", "]r", function()
        next_reference()
      end, opts)
    end,
  })

  local env = require("conf.env")

  vim.lsp.config('gopls', {
    init_options = {
      buildFlags = { "-tags=integration" },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
    settings = {
      gopls = {
        ["local"] = env.NVIM_GOPLS_LOCAL,
      },
    },
  })
  vim.lsp.enable('gopls')

  if require("conf.env").NVIM_TS_LSP == "astro" then
    vim.lsp.config('astro', {
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "astro",
        "json",
      },
    })
    vim.lsp.enable('astro')
  end

  if require("conf.env").NVIM_TS_LSP == "volar" then
    vim.lsp.config('volar', {
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
      },
      init_options = {
        typescript = {
          tsdk = vim.env.HOME .. "/dev/node_modules/typescript/lib",
        },
      },
    })
    vim.lsp.enable('volar')
  end

  if require("conf.env").NVIM_TS_LSP == "vtsls" then
    vim.lsp.enable('vtsls')
  end

  vim.lsp.enable('lua_ls')
  vim.lsp.enable('pylsp')
  vim.lsp.enable('terraformls')

  -- vim.lsp.config('java_language_server', {
  --   cmd = { "/home/robotx/g/java-language-server/dist/lang_server_linux.sh" },
  -- })
  -- vim.lsp.enable('java_language_server')

  vim.lsp.enable('jdtls')
end

return M
