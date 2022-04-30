# nvim-config

- `rm -rf ~/.config/nvim && rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim` to remove old config & installs
- `git clone --depth=1 https://github.com/marcelbeumer/nvim-config ~/.config/nvim` to clone this config
- `git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim` to install [paq](https://github.com/savq/paq-nvim)
- `nvim --headless -c 'autocmd User PaqDoneSync quitall' -c 'PaqSync'` to install plugins (ignore initial error)
- `nvim`, treesitter will compile parsers automatically (manually do `:TSUpdate` after `treesitter` updates)
