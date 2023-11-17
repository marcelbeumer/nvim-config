local M = {}

M.setup = function()
  local bind_all = require("conf0.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  require("lsp-inlayhints").setup({ enabled_at_startup = false })

  vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      require("lsp-inlayhints").on_attach(client, bufnr)
    end,
  })

  bind_all("lsp.toggle_inlayhints", require("lsp-inlayhints").toggle, {}, key_opts)
end

return M
