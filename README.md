# nvim-config

Personal nvim config for neovim. Implicit system dependencies may cause errors on other machines.

## Install

- Copy/clone contents of this repo to `~/.config/nvim`.
- Run `nvim`. The [lazy](https://github.com/folke/lazy.nvim) package manager should install plugins automatically.

## Usage

Just `nvim`. Optionally use environment variables [defined here](./lua/conf/env.lua). For example: `NVIM_AUTOFORMAT=off NVIM_LSP=off nvim`.

## Notable plugins no longer used

- "jackplus-xyz/binary.nvim": awesome single color colorscheme, but unpractical with UI (selection etc).

