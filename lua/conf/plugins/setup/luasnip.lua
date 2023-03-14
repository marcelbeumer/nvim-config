local M = {}

M.setup = function()
  local ls = require("luasnip")

  ls.setup({
    history = true,
    update_events = { "TextChanged", "TextChangedI" },
    -- enable_autosnippets = true,
  })

  -- vim.keymap.set({ "i", "s" }, "<tab>", function()
  --   if ls.expand_or_jumpable() then
  --     return ls.expand_or_jump()
  --   end
  -- end, { silent = true })
  --
  -- vim.keymap.set({ "i", "s" }, "<s-tab>", function()
  --   if ls.jumpable(-1) then
  --     return ls.jump(-1)
  --   end
  -- end, { silent = true })
  --
  -- vim.keymap.set({ "i", "s" }, "<c-e>", function()
  --   if ls.choice_active() then
  --     return ls.change_choice(1)
  --   end
  -- end, { silent = true })

  ls.add_snippets("typescript", {
    ls.parser.parse_snippet("l", "console.log($1)$0"),
    ls.parser.parse_snippet("lj", 'console.log("$1", JSON.stringify($2, null, 2))$0'),
    ls.parser.parse_snippet("d", "debugger$0"),
  })

  ls.add_snippets("go", {
    ls.parser.parse_snippet("ir", "if err != nil {\n\treturn $1\n}$0"),
  })
end

return M
