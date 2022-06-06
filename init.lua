local env = require("conf.env")

if env.NVIM_STARTUP == "bare" then
  -- nothing
elseif env.NVIM_STARTUP == "plugreg" then
  require("conf2.plugins").register()
elseif env.NVIM_STARTUP == "normal" then
  require("conf2").setup()
elseif env.NVIM_STARTUP == "old" then
  require("conf").setup()
end
