local util = require("conf.lsp.util")

local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function(data)
      local settings = vim.tbl_deep_extend("force", require("neodev").setup({}), {
        Lua = {
          completion = {
            showWord = "Disable",
            callSnippet = "Disable",
            keywordSnippet = "Disable",
          },
        },
      })
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
        settings = settings,
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
