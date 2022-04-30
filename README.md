# nvim-config

- `rm -rf ~/.config/nvim` to remove old config
- `rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim` to remove old installs
- `git clone --depth=1 https://github.com/marcelbeumer/nvim-config ~/.config/nvim` to clone this config
- `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim` to install [packer](https://github.com/wbthomason/packer.nvim)
- `PLUGIN_REGISTER_ONLY=1 nvim +PackerSync` to install plugins (quit when done)
- `nvim`, treesitter will compile parsers automatically (from now on manually do `:TSUpdate` when `treesitter` updates)
