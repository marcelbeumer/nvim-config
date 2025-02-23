local env = require("conf.env")

if env.NVIM_STARTUP == "safe" then
  return
end

require("conf.globals")
require("conf.base")

if env.NVIM_STARTUP == "base" then
  return
end

require("conf.extra.statusline").setup()
require("conf.extra.jump").setup()
require("conf.extra.layout").setup()
require("conf.extra.panels").setup()
require("conf.extra.filepath").setup()
require("conf.extra.quickfix").setup()
require("conf.extra.colorscheme").setup()

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
