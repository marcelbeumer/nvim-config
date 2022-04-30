# nvim-config

- `rm -rf ~/.config/nvim && rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim` to remove old config & installs
- `git clone --depth=1 https://github.com/marcelbeumer/nvim-config ~/.config/nvim` to clone this config
- `git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim` to install [paq](https://github.com/savq/paq-nvim)
- `PLUGIN_REGISTER_ONLY=1 nvim +PaqSync` to install plugins (quit when done)
- `nvim`, treesitter will compile parsers automatically (from now on manually do `:TSUpdate` when `treesitter` updates)
