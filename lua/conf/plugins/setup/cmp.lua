local M = {}

M.setup = function()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local luasnip = require("luasnip")
  local icons = require("conf.icons")
  local bindings = require("conf.bindings")
  local keys = bindings.config.cmp

  vim.o.completeopt = "menu,menuone,noselect"
  vim.o.pumheight = 10
  cmp.setup.global({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
    },
    formatting = {
      fields = { "kind", "abbr" },
      format = function(_, item)
        item.kind = icons.kind[item.kind]
        return item
      end,
    },
    mapping = cmp.mapping.preset.insert({
      [keys.open.value] = cmp.mapping.complete({}),
      [keys.abort.value] = cmp.mapping.abort(),
      [keys.confirm.value] = cmp.mapping.confirm({ select = true }),
    }),
  })

  local compare = cmp.config.compare
  cmp.setup.filetype({ "go" }, {
    -- gopls preselects items which I don't like.
    preselect = types.cmp.PreselectMode.None,
    sorting = {
      -- IMO these comparator settings work better with gopls.
      priority_weight = 2,
      comparators = {
        -- gopls most (only? relevant
        compare.sort_text,
        -- cmp defaults:
        compare.offset,
        compare.exact,
        -- compare.scopes,
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.kind,
        -- compare.sort_text,
        compare.length,
        compare.order,
      },
    },
  })
end

return M
