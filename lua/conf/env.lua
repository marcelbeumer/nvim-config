return {
  -- NVIM_DARK=<on|off>
  -- Configures using dark theme or not.
  -- on (default)
  -- off
  NVIM_DARK = vim.env.NVIM_DARK or "on",

  -- NVIM_LSP=<on|off>
  -- Configures using LSP or not.
  -- on (default)
  -- off
  NVIM_LSP = vim.env.NVIM_LSP or "on",

  -- NVIM_AUTOFORMAT=<on|off>
  -- Configures using autoformatting on save not.
  -- on (default)
  -- off
  NVIM_AUTOFORMAT = vim.env.NVIM_AUTOFORMAT or "on",

  -- NVIM_GOPLS_LOCAL="git.company.com"
  -- Configures gopls local packages for importing grouping to work.
  NVIM_GOPLS_LOCAL = vim.env.NVIM_GOPLS_LOCAL or "",
}
