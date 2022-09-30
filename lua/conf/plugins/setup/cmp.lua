local M = {}

M.setup = function()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local luasnip = require("luasnip")

  vim.o.completeopt = "menu,menuone,noselect"
  vim.o.pumheight = 10
  cmp.setup.global({
    experimental = { ghost_text = true },
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
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
  })

  cmp.setup.filetype({ "go" }, {
    -- gopls preselects items which I don't like.
    preselect = types.cmp.PreselectMode.None,
    sorting = {
      -- IMO these comparator settings work better with gopls.
      comparators = {
        cmp.config.compare.length,
        cmp.config.compare.locality,
        cmp.config.compare.sort_text,
      },
    },
  })
end

return M
