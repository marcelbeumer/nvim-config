local util = require("conf.lsp.util")

local M = {}

M.setup = function()
  local init_options = {
    hints = {
      assignVariableTypes = true,
      compositeLiteralFields = true,
      constantValues = true,
      functionTypeParameters = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
    buildFlags = { "-tags=integration" },
    -- gofumpt = true, -- using null_ls gofumpt is faster when imports changed too
  }

  local env = require("conf.env")
  if env.NVIM_GOPLS_LOCAL ~= "" then
    init_options["local"] = env.NVIM_GOPLS_LOCAL
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "go,gomod,gowork,gotmpl",
    callback = function(data)
      vim.lsp.start({
        name = "gopls",
        cmd = { "gopls" },
        root_dir = util.find_root_dir({ "go.work" }, data.file)
          or util.find_root_dir({ "go.mod", ".git" }, data.file)
          or vim.fn.getcwd(),
        init_options = init_options,
        handlers = util.get_handlers(),
        capabilities = util.get_capabilities(),
        on_attach = function(client)
          util.disable_formatting(client)
        end,
      })
    end,
  })
end

function M.client()
  local clients = vim.lsp.get_active_clients()
  for _, cl in pairs(clients) do
    if cl.name == "gopls" then
      return cl
    end
  end
end

M.organize_imports_sync = function()
  local c = M.client()
  if not c then
    return
  end
  util.codeaction_sync(c, "", "source.organizeImports", 1000)
end

M.organize_imports = function()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports" },
    },
    apply = true,
  })
end

return M
