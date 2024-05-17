return {
  { "williamboman/mason.nvim", opts = {} },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Servers are configured in plugins/lang/*
      servers = {},
    },

    config = function(_, opts)
      if require("conf.env").NVIM_LSP == "off" then
        return
      end

      local lspconfig = require("lspconfig")
      local util = require("conf.util.lsp")
      local map = vim.keymap.set

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
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end

          local opts = { buffer = args.buf }
          map("n", "<leader>q", vim.lsp.buf.document_highlight, opts)
          map("n", "<space>h", vim.lsp.buf.document_highlight, opts)
          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "gt", vim.lsp.buf.type_definition, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "gi", vim.lsp.buf.implementation, opts)
          map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          map("i", "<C-y>", vim.lsp.buf.signature_help, opts)
          map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          map("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          map("n", "<space>rn", vim.lsp.buf.rename, opts)
          map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          map("n", "gr", vim.lsp.buf.references, opts)
          map("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          map("n", "<space>I", util.organize_imports)
          map("n", "<space>H", function()
            local enabled = not vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(enabled)
          end, opts)

          map("n", "[r", function()
            util.next_reference(true)
          end, opts)
          map("n", "]r", function()
            util.next_reference()
          end, opts)
        end,
      })

      -- Servers are configured in plugins/lang/*
      for name, conf in pairs(opts.servers) do
        if type(conf) == "function" then
          local result = conf()
          if result then
            lspconfig[name].setup(result)
          end
        else
          lspconfig[name].setup(conf)
        end
      end
    end,
  },
}
