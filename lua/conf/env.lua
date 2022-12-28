return {
  -- NVIM_STARTUP=<normal|base|safe|plugreg>
  -- normal: normal startup (default)
  -- base: only base settings, no plugin/lsp setup
  -- safe: nvim without any user config
  NVIM_STARTUP = vim.env.NVIM_STARTUP or "normal",
  -- NVIM_LSP=<on|off>
  -- on: set up LSP (default)
  -- off: do not setup LSP
  NVIM_LSP = vim.env.NVIM_LSP or "on",
  -- NVIM_TS_LSP=<tsserver|volar|none>
  -- tsserver: use `tsserver` LSP server (default)
  -- volar: use `volar` vue LSP server
  -- none: no TS LSP server
  NVIM_TS_LSP = vim.env.NVIM_TS_LSP or "tsserver",
  -- NVIM_LSP_AUTO_FORMAT=<on|off>
  -- on: enable LSP auto formatting (default)
  -- off: disable LSP auto formatting
  NVIM_LSP_AUTO_FORMAT = vim.env.NVIM_LSP_AUTO_FORMAT or "on",
  -- NVIM_GOTMPL_YAML=<on|off>
  -- on: enable autodetecting yaml as gotmpl
  -- off: disable autodetecting yaml as gotmpl (default)
  NVIM_GOTMPL_YAML = vim.env.NVIM_GOTMPL_YAML or "off",
}
