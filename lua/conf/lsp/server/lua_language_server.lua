local util = require("conf.lsp.util")

local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function(data)
      local luadev = require("lua-dev").setup({})
      vim.lsp.start({
        name = "lua-language-server",
        cmd = { "lua-language-server" },
        root_dir = util.find_root_dir({
          ".luarc.json",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "lua/",
        }, data.file) or vim.fn.getcwd(),
        settings = luadev.settings,
        handlers = util.get_handlers(),
        capabilities = util.get_capabilities(),
        on_attach = function(client)
          util.disable_formatting(client)
        end,
      })
    end,
  })
end

return M