return {
  -- NVIM_STARTUP=<normal|base|safe|plugreg>
  -- Starts nvim in different modes:
  -- normal: normal startup (default)
  -- base: only base settings, no plugin/lsp setup
  -- safe: nvim without any user config
  NVIM_STARTUP = vim.env.NVIM_STARTUP or "normal",

  -- NVIM_LSP=<on|off>
  -- Configures using LSP or not.
  -- on (default)
  -- off
  NVIM_LSP = vim.env.NVIM_LSP or "on",

  -- NVIM_TS_LSP=<tsserver|volar|none>
  -- Configures which LSP server to use for TypeScript.
  -- vtsls: use `vtsls` LSP server (default)
  -- tsserver: use `tsserver` LSP server
  -- volar: use `volar` vue LSP server
  -- none: no TS LSP server
  NVIM_TS_LSP = vim.env.NVIM_TS_LSP or "vtsls",

  -- NVIM_LSP_AUTO_FORMAT=<on|off>
  -- Configures using autoformatting with LSP or not.
  -- on (default)
  -- off
  NVIM_LSP_AUTO_FORMAT = vim.env.NVIM_LSP_AUTO_FORMAT or "on",

  -- NVIM_GOTMPL_YAML=<on|off>
  -- Configures autodetecting yaml as gotmpl.
  -- on (default)
  -- off
  NVIM_GOTMPL_YAML = vim.env.NVIM_GOTMPL_YAML or "off",

  -- NVIM_GOPLS_LOCAL=<prefix-import-path>
  -- Configures the gopls "local" string for import ordering, see:
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  -- Empty value omits the setting.
  NVIM_GOPLS_LOCAL = vim.env.NVIM_GOPLS_LOCAL or "",

  -- NVIM_ENABLE_COPILOT=<on|off>
  -- Configures enabling Github Copilot or not.
  -- on (default)
  -- off
  NVIM_ENABLE_COPILOT = vim.env.NVIM_ENABLE_COPILOT or "on",
}
