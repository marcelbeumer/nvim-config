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
    -- view = {
    --   entries = "wildmenu", -- can be "custom", "wildmenu" or "native"
    -- },
    -- experimental = { ghost_text = true },
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
      { name = "nvim_lsp_signature_help" },
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
