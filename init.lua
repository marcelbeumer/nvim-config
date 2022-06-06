local env = require("conf2.env")

if env.NVIM_STARTUP == "bare" then
  -- nothing
elseif env.NVIM_STARTUP == "plugreg" then
  require("conf2.plugins").register()
elseif env.NVIM_STARTUP == "normal" then
  require("conf2").setup()
end
