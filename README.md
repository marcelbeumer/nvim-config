# nvim-config

Personal nvim config for [neovim nightly](https://github.com/marcelbeumer/neovim). Implicit system dependencies may cause errors on other machines.

## Install

- Copy/clone contents of this repo to `~/.config/nvim`.
- Install [packer](https://github.com/wbthomason/packer.nvim) with `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`.
- Do initial install of plugins with `NVIM_STARTUP=plugreg nvim +PackerSync`. Run again when some plugins [fail to install](https://github.com/wbthomason/packer.nvim/issues/897).

## Usage

Just `nvim`. Optionally use following [environment variables defined here](./lua/conf/env.lua). For example: `NVIM_LSP_AUTO_FORMAT=off NVIM_TS_LSP=volar nvim`.
