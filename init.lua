if vim.env.NVIM_CONF == "new" then
  require("conf")
else
  require("conf0").setup()
end
