# nvim-config

Personal nvim config for [neovim nightly](https://github.com/marcelbeumer/neovim). Implicit system dependencies may cause errors on other machines. I put effort in keeping the config clean and documented, mostly as a hobby and a bit of OCD, but maybe it benefits other nvimmers too.

> While neovim users are in search of their perfect config, others are doing actual work using VS Code.
>
> -- <cite>Zen monk, long time ago.</cite>

## Install

- Copy/clone contents of this repo to `~/.config/nvim`.
- Run `nvim`. The [lazy](https://github.com/folke/lazy.nvim) package manager should install plugins automatically.

## Usage

Just `nvim`. Optionally use environment variables [defined here](./lua/conf/env.lua). For example: `NVIM_LSP_AUTO_FORMAT=off NVIM_TS_LSP=volar nvim`.
