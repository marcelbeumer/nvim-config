local util = require("conf.lsp.util")

local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go,gomod,gowork,gotmpl",
    callback = function(data)
      vim.lsp.start({
        name = "gopls",
        cmd = { "gopls" },
        root_dir = util.find_root_dir({ "go.work" }, data.file)
          or util.find_root_dir({ "go.mod", ".git" }, data.file)
          or vim.fn.getcwd(),
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
