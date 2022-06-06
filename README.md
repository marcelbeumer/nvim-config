# nvim-config

Personal nvim config for [neovim nightly](https://github.com/marcelbeumer/neovim). Implicit system dependencies may cause errors on other machines.

## Install

- `rm -rf ~/.config/nvim` to remove old config
- `rm -rf ~/.local/share/nvim` to remove old installs
- `git clone --depth=1 https://github.com/marcelbeumer/nvim-config ~/.config/nvim` to clone this config
- `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim` to install [packer](https://github.com/wbthomason/packer.nvim)
- `NVIM_STARTUP=plugreg nvim +PackerSync` to install plugins (quit when done; run again when some plugins [fail to install](https://github.com/wbthomason/packer.nvim/issues/897))
- `nvim`, treesitter will compile parsers automatically (from now on manually do `:TSUpdate` when `treesitter` updates)

## Usage

Optionally use following environment variables:

- `NVIM_STARTUP=<normal|bare|plugreg>`
  - `normal`: normal startup (default)
  - `base`: only base settings, no plugin/lsp setup
  - `safe`: nvim without any user config
  - `plugreg`: only register plugins
- `NVIM_LSP=<on|off>`
  - `on`: set up LSP (default)
  - `off`: do not setup LSP
- `NVIM_LSP_AUTO_FORMAT=<on|off>`
  - `on`: enable LSP auto formatting (default)
  - `off`: disable LSP auto formatting
- `NVIM_TS_LSP=<tsserver|volar|none>`
  - `tsserver`: use `tsserver` LSP server (default)
  - `volar`: use `volar` vue LSP server
  - `none`: no TS LSP server

Example: `NVIM_LSP_AUTO_FORMAT=off NVIM_TS_LSP=volar nvim`
