# nvim-config

Personal nvim config for [neovim nightly](https://github.com/marcelbeumer/neovim). Implicit system dependencies may cause errors on other machines.

## Install

- `rm -rf ~/.config/nvim` to remove old config
- `rm -rf ~/.local/share/nvim` to remove old installs
- `git clone --depth=1 https://github.com/marcelbeumer/nvim-config ~/.config/nvim` to clone this config
- `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim` to install [packer](https://github.com/wbthomason/packer.nvim)
- `NVIM_STARTUP=plugreg nvim +PackerSync` to install plugins (quit when done; run again when some plugins [fail to install](https://github.com/wbthomason/packer.nvim/issues/897))
- `nvim`, treesitter will compile parsers automatically

## Usage

Optionally use following [environment variables defined here](./lua/conf/env.lua). For example: `NVIM_LSP_AUTO_FORMAT=off NVIM_TS_LSP=volar nvim`
