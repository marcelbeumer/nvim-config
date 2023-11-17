local util = require("conf0.lsp.util")

local M = {}

M.setup = function()
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.terraform_fmt,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.gofumpt,
      -- null_ls.builtins.diagnostics.eslint_d,
      -- null_ls.builtins.diagnostics.staticcheck.with({
      --   cwd = function()
      --     return vim.fn.getcwd()
      --   end,
      --   diagnostics_postprocess = function(diagnostic)
      --     if diagnostic.severity == vim.diagnostic.severity["ERROR"] then
      --       diagnostic.severity = vim.diagnostic.severity["WARN"]
      --     end
      --   end,
      -- }),
      -- null_ls.builtins.diagnostics.golangci_lint.with({
      --   args = {
      --     "run",
      --     "--out-format=json",
      --   },
      -- }),
    },
    capabilities = util.get_capabilities(),
    handlers = util.get_handlers(),
  })
end

return M
