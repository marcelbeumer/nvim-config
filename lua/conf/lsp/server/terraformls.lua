local util = require("conf.lsp.util")

local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function(data)
      vim.lsp.start({
        name = "terraformls",
        cmd = { "terraform-ls", "serve" },
        root_dir = util.find_root_dir({ ".terraform", ".git" }, data.file) or vim.fn.getcwd(),
        handlers = util.get_handlers(),
        capabilities = util.get_capabilities(),
      })
    end,
  })
end

return M
