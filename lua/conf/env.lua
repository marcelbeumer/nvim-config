return {
  -- NVIM_STARTUP=<normal|base|safe|plugreg>
  -- Starts nvim in different modes:
  -- normal: normal startup (default)
  -- base: only base settings, no plugin/lsp setup
  -- safe: nvim without any user config
  NVIM_STARTUP = vim.env.NVIM_STARTUP or "normal",

  -- NVIM_TREESITTER=<on|off>
  -- Configures using treesitter or not.
  -- on
  -- off (default)
  NVIM_TREESITTER = vim.env.NVIM_TREESITTER or "off",

  -- NVIM_SYNTAX=<on|off>
  -- Configures having syntax highlighting or not.
  -- on
  -- off (default)
  NVIM_SYNTAX = vim.env.NVIM_SYNTAX or "off",

  -- NVIM_LSP=<on|off>
  -- Configures using LSP or not.
  -- on (default)
  -- off
  NVIM_LSP = vim.env.NVIM_LSP or "on",

  -- NVIM_TS_LSP=<volar|vtsls>
  -- Configures which LSP to use for TypeScript.
  -- vtsls (default)
  -- volar
  -- astro
  NVIM_TS_LSP = vim.env.NVIM_TS_LSP or "vtsls",

  -- NVIM_AUTOFORMAT=<on|off>
  -- Configures using autoformatting on save not.
  -- on (default)
  -- off
  NVIM_AUTOFORMAT = vim.env.NVIM_AUTOFORMAT or "on",

  -- NVIM_GOPLS_LOCAL="git.company.com"
  -- Configures gopls local packages for importing grouping to work.
  NVIM_GOPLS_LOCAL = vim.env.NVIM_GOPLS_LOCAL or "",
}
