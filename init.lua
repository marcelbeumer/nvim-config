if vim.env.NO_PLUGINS == "1" then
	-- nothing
elseif vim.env.PLUGIN_REGISTER_ONLY == "1" then
	require("conf.plugins").register()
else
	require("conf").setup()
end
