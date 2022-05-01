# nvim-config

## Install

- `rm -rf ~/.config/nvim` to remove old config
- `rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim` to remove old installs
- `git clone --depth=1 https://github.com/marcelbeumer/nvim-config ~/.config/nvim` to clone this config
- `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim` to install [packer](https://github.com/wbthomason/packer.nvim)
- `NVIM_STARTUP=plugreg nvim +PackerSync` to install plugins (quit when done)
- `nvim`, treesitter will compile parsers automatically (from now on manually do `:TSUpdate` when `treesitter` updates)

## Usage

Optionally use following environment variables:

- `NVIM_STARTUP=<normal|bare|plugreg>`
  - `normal`: normal startup (default)
  - `bare`: bare nvim without config
  - `plugreg`: only register plugins
  - example: `NVIM_STARTUP=plugreg nvim +PackerSync`
- `NVIM_TS_LSP=<tsserver|volar>`
  - `tsserver`: use `tsserver` LSP server (default)
  - `volar`: use `volar` vue LSP server
  - example: `NVIM_TS_LSP=volar nvim`
