local M = {}

M.setup = function()
  local fzf = require("fzf-lua")
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local cmd_opts = {}
  local key_opts = { noremap = true, silent = true }

  fzf.setup({
    winopts = { preview = { layout = "vertical" } },
    previewers = { builtin = { syntax = false } },
  })

  local args_small = { previewer = false, winopts = { height = 20 } }
  local args_tall = { previewer = false, winopts = { height = 0.80 } }

  bind_all("find.files", function()
    fzf.files(args_small)
  end, cmd_opts, key_opts)
  bind_all("find.buffers", function()
    fzf.buffers(args_tall)
  end, cmd_opts, key_opts)
  bind_all("find.quickfix", function()
    fzf.quickfix(args_tall)
  end, cmd_opts, key_opts)
  bind_all("find.loclist", function()
    fzf.loclist(args_tall)
  end, cmd_opts, key_opts)
  bind_all("find.commands", fzf.commands, cmd_opts, key_opts)
  bind_all("find.ripgrep", fzf.live_grep_native, cmd_opts, key_opts)
  bind_all("find.ripgrep_buffer", fzf.grep_curbuf, cmd_opts, key_opts)
  bind_all("find.diag", fzf.diagnostics_workspace, cmd_opts, key_opts)
  bind_all("find.diag_buffer", fzf.diagnostics_document, cmd_opts, key_opts)
  bind_all("find.lsp_references", fzf.lsp_references, cmd_opts, key_opts)
  bind_all("find.lsp_symbols", fzf.lsp_workspace_symbols, cmd_opts, key_opts)
  bind_all("find.lsp_symbols_buffer", fzf.lsp_document_symbols, cmd_opts, key_opts)
  bind_all("find.lsp_implementations", fzf.lsp_implementations, cmd_opts, key_opts)
  bind_all("find.lsp_definitions", fzf.lsp_definitions, cmd_opts, key_opts)
  bind_all("find.lsp_declarations", fzf.lsp_declarations, cmd_opts, key_opts)
  bind_all("find.lsp_typedefs", fzf.lsp_typedefs, cmd_opts, key_opts)
  bind_all("find.help", fzf.help_tags, cmd_opts, key_opts)

  bind_all("find.projects", function()
    local contents = require("project_nvim").get_recent_projects()
    local reverse = {}
    for i = #contents, 1, -1 do
      reverse[#reverse + 1] = contents[i]
    end
    require("fzf-lua").fzf_exec(reverse, {
      actions = {
        ["default"] = function(e)
          vim.cmd.cd(e[1])
        end,
        ["ctrl-d"] = function(x)
          local choice = vim.fn.confirm("Delete '" .. #x .. "' projects? ", "&Yes\n&No", 2)
          if choice == 1 then
            local history = require("project_nvim.utils.history")
            for _, v in ipairs(x) do
              history.delete_project(v)
            end
          end
        end,
      },
    })
  end, cmd_opts, key_opts)
end

return M
