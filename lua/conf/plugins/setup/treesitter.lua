local M = {}

M.setup = function()
  local env = require("conf.env")

  -- Add gotmpl support. Requires scm file(s) in <repo>/queries/gotmpl.
  -- Not using the language injection because yaml and gotmpl don't play well
  -- together when mixed (probably bugs in parser). Instead, we implement
  -- automatic filetype switching for yaml.
  require("nvim-treesitter.parsers").get_parser_configs().gotmpl = {
    filetype = "gotmpl",
    used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl" },
    install_info = {
      url = "https://github.com/ngalaiko/tree-sitter-go-template",
      files = { "src/parser.c" },
    },
  }

  -- Terraform
  vim.cmd([[au BufNewFile,BufRead *.tf set ft=terraform ]])
  vim.cmd([[au BufNewFile,BufRead *.hcl,*.terraformrc,terraform.rc set ft=hcl ]])
  vim.cmd([[au BufNewFile,BufRead *.tfstate,*.tfstate.backup set ft=json ]])

  -- Treat .tpl and tmpl as gotmpl
  vim.cmd([[au BufNewFile,BufRead *.tpl set ft=gotmpl ]])
  vim.cmd([[au BufNewFile,BufRead *.tmpl set ft=gotmpl ]])

  if env.NVIM_GOTMPL_YAML == "on" then
    -- Treat .y(a)ml as gotmpl when buffer has template tags. Updates on save.
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWritePre" }, {
      pattern = { "*.yaml", "*.yml" },
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, line in ipairs(lines) do
          if line:match("{{.+}}") then
            vim.bo.ft = "gotmpl"
            return
          end
        end
        vim.bo.ft = "yaml"
      end,
    })
  end

  -- Set up treesitter itself.
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    -- phpdoc gave errors on darwin-arm64.
    ignore_install = { "phpdoc" },
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  })

  -- TODO: make lua API
  vim.cmd([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set foldlevel=99
  ]])

  -- Workaround for slow go files:
  -- https://github.com/NvChad/NvChad/issues/1415#issuecomment-1203723816
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3263
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3187
  require("vim.treesitter.query").set_query("go", "injections", "(comment) @comment")
end

return M