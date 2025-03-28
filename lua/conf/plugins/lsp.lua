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
      local util = require("conf.lsp")
      local map = vim.keymap.set

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end

          local opts = { buffer = args.buf }
          map("n", "grt", vim.lsp.buf.type_definition, opts)
          map("n", "grh", vim.lsp.buf.document_highlight, opts)
          map("n", "grc", vim.lsp.buf.clear_references, opts)
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
