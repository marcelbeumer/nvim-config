local env = require("conf.env")

if env.NVIM_STARTUP ~= "safe" then
  require("conf.base")
  require("conf.globals")

  if env.NVIM_STARTUP ~= "base" then
    require("conf.extra.layout").setup()
    require("conf.extra.panels").setup()
    require("conf.extra.filepath").setup()
    require("conf.extra.quickfix").setup()

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
    -- vim.cmd([[colorscheme tokyonight]])
    -- vim.cmd([[colorscheme melange]])
    vim.cmd([[set background=light]])
    vim.cmd([[colorscheme catppuccin]])
    -- vim.cmd([[colorscheme default]])
  end
end
