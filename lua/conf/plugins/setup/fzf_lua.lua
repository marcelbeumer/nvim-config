local M = {}

M.setup = function()
  local fzf = require("fzf-lua")
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  fzf.setup({
    winopts = { preview = { layout = "vertical" } },
    previewers = { builtin = { syntax = false } },
    files = {
      cwd_prompt = false,
      file_icons = false,
    },
    grep = {
      file_icons = false,
      git_icons = false,
      rg_glob = true,
    },
    fzf_colors = {
      ["fg"] = { "fg", "CursorLine" },
      ["bg"] = { "bg", "Normal" },
      ["hl"] = { "fg", "Comment" },
      ["fg+"] = { "fg", "Normal" },
      ["bg+"] = { "bg", "CursorLine" },
      ["hl+"] = { "fg", "Statement" },
      ["info"] = { "fg", "PreProc" },
      ["prompt"] = { "fg", "Conditional" },
      ["pointer"] = { "fg", "Exception" },
      ["marker"] = { "fg", "Keyword" },
      ["spinner"] = { "fg", "Label" },
      ["header"] = { "fg", "Comment" },
      ["gutter"] = { "bg", "Normal" },
    },
  })

  local args_small = { previewer = false, winopts = { width = 0.6, height = 20 } }
  local args_tall = { previewer = false, winopts = { width = 0.6, height = 0.80 } }

  bind_all("find.files", function()
    fzf.files(args_small)
  end, {}, key_opts)
  bind_all("find.buffers", function()
    fzf.buffers(args_tall)
  end, {}, key_opts)
  bind_all("find.quickfix", function()
    fzf.quickfix(args_tall)
  end, {}, key_opts)
  bind_all("find.loclist", function()
    fzf.loclist(args_tall)
  end, {}, key_opts)
  bind_all("find.commands", fzf.commands, {}, key_opts)
  bind_all("find.ripgrep", fzf.live_grep_resume, {}, key_opts)
  bind_all("find.ripgrep_buffer", fzf.grep_curbuf, {}, key_opts)
  bind_all("find.diag", fzf.diagnostics_workspace, {}, key_opts)
  bind_all("find.diag_buffer", fzf.diagnostics_document, {}, key_opts)
  bind_all("find.lsp_references", fzf.lsp_references, {}, key_opts)
  bind_all("find.lsp_symbols", fzf.lsp_workspace_symbols, {}, key_opts)
  bind_all("find.lsp_symbols_buffer", fzf.lsp_document_symbols, {}, key_opts)
  bind_all("find.lsp_implementations", fzf.lsp_implementations, {}, key_opts)
  bind_all("find.lsp_definitions", fzf.lsp_definitions, {}, key_opts)
  bind_all("find.lsp_declarations", fzf.lsp_declarations, {}, key_opts)
  bind_all("find.lsp_typedefs", fzf.lsp_typedefs, {}, key_opts)
  bind_all("find.help", fzf.help_tags, {}, key_opts)

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
  end, {}, key_opts)
end

return M
