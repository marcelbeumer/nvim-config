local env = require("conf.env")

require("conf.globals")
require("conf.neovide").setup()
require("conf.options")
require("conf.autocmds")
require("conf.cmds")
require("conf.keymaps")
require("conf.diagnostic")
require("conf.statusline").setup()
require("conf.jump").setup()
require("conf.layout").setup()
require("conf.panels").setup()
require("conf.filepath").setup()
require("conf.quickfix").setup()
require("conf.colorscheme").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup("conf.plugins", {
  change_detection = {
    enabled = false,
  },
})
