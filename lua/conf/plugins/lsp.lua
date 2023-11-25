return {
  { "williamboman/mason.nvim", opts = {} },

  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.o.updatetime = 250
    end,

    opts = {
      servers = {},
    },

    config = function(_, opts)
      if require("conf.env").NVIM_LSP == "off" then
        return
      end

      local lspconfig = require("lspconfig")
      local util = require("conf.util.lsp")
      local map = vim.keymap.set

      util.disable_lsp_semantic_highlighting()

      map("n", "<space>d", vim.diagnostic.open_float)
      map("n", "[d", vim.diagnostic.goto_prev)
      map("n", "]d", vim.diagnostic.goto_next)
      map("n", "<space>q", vim.diagnostic.setloclist)

      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        handlers = {
          ["textDocument/hover"] = function(err, result, ctx, config)
            local final_config = vim.tbl_deep_extend("force", config or {}, { border = "rounded" })
            local buf_id, win_id = vim.lsp.handlers.hover(err, result, ctx, final_config)

            if win_id ~= nil then
              vim.api.nvim_win_set_option(win_id, "linebreak", true)
              vim.api.nvim_win_set_option(win_id, "showbreak", "NONE")
              return buf_id, win_id
            end
          end,
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
          end
          if client.server_capabilities.definitionProvider then
            vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
          end

          if client.supports_method("textDocument/documentHighlight") then
            local enabled = true
            local update = function()
              if enabled then
                vim.lsp.buf.document_highlight()
              end
            end

            local clear = function()
              if enabled then
                vim.lsp.buf.clear_references()
              end
            end

            map("n", "<space>h", function()
              enabled = not enabled
              clear()
              update()
            end, { buffer = bufnr })

            local hl = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
            vim.api.nvim_clear_autocmds({ group = hl, buffer = bufnr })
            vim.api.nvim_create_autocmd("CursorHold", { group = hl, buffer = bufnr, callback = update })
            vim.api.nvim_create_autocmd("CursorHoldI", { group = hl, buffer = bufnr, callback = update })
            vim.api.nvim_create_autocmd("CursorMoved", { group = hl, buffer = bufnr, callback = clear })
          end

          local mopts = { buffer = bufnr }
          map("n", "gD", vim.lsp.buf.declaration, mopts)
          map("n", "gd", vim.lsp.buf.definition, mopts)
          map("n", "gt", vim.lsp.buf.type_definition, mopts)
          map("n", "K", vim.lsp.buf.hover, mopts)
          map("n", "gi", vim.lsp.buf.implementation, mopts)
          map("n", "<C-k>", vim.lsp.buf.signature_help, mopts)
          map("i", "<C-y>", vim.lsp.buf.signature_help, mopts)
          map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, mopts)
          map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, mopts)
          map("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, mopts)
          map("n", "<space>D", vim.lsp.buf.type_definition, mopts)
          map("n", "<space>rn", vim.lsp.buf.rename, mopts)
          map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, mopts)
          map("n", "gr", vim.lsp.buf.references, mopts)
          map("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, mopts)

          map("n", "[r", function()
            util.next_reference(true)
          end, mopts)
          map("n", "]r", function()
            util.next_reference()
          end, mopts)
        end,
      })

      -- Servers are configured in plugins/lang/*
      for name, cfg in pairs(opts.servers) do
        lspconfig[name].setup(cfg)
      end
    end,
  },
}
