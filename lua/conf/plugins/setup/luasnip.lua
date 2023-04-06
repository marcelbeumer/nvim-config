local M = {}

M.setup = function()
  local ls = require("luasnip")

  ls.setup({
    history = true,
    update_events = { "TextChanged", "TextChangedI" },
    -- enable_autosnippets = true,
  })

  vim.cmd([[
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
  ]])

  ls.add_snippets("typescript", {
    ls.parser.parse_snippet("l", "console.log($1)$0"),
    ls.parser.parse_snippet("lj", 'console.log("$1", JSON.stringify($2, null, 2))$0'),
    ls.parser.parse_snippet("d", "debugger$0"),
  })

  ls.add_snippets("go", {
    ls.parser.parse_snippet("ir", "if err != nil {\n\treturn $1\n}$0"),
    ls.parser.parse_snippet("pl", "fmt.Println($1)$0"),
    ls.parser.parse_snippet("pf", 'fmt.Printf("$1", $2)$0'),
    ls.parser.parse_snippet("sf", 'fmt.Sprintf("$1", $2)$0'),
    ls.parser.parse_snippet("r", "return $0"),
    ls.parser.parse_snippet("rn", "return nil$0"),
    ls.parser.parse_snippet("re", "return err$0"),
  })
end

return M
