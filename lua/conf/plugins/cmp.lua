local M = {}

M.setup = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  vim.o.completeopt = "menu,menuone,noselect"
  vim.o.pumheight = 10

  cmp.setup.global({
    experimental = {
      ghost_text = true,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = {
        i = cmp.mapping.confirm({ select = true }),
      },
    }),
  })

  cmp.setup.filetype({ "go" }, {
    sorting = {
      comparators = {
        -- Sorting with gopls is good as it is
        -- so we disable additional sorting.
      },
    },
  })

  cmp.setup.filetype({
    "typescript",
    "typescriptreact",
    "javascript",
    "javascriptreact",
    "vue",
  }, {
    sorting = {
      -- Specific for typescript-language-server/volar
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.locality,
        -- cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.score,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  })
end

M.get_lsp_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require("cmp_nvim_lsp").update_capabilities(capabilities)
end

return M
