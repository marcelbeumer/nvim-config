local M = {}

M.setup = function()
  local get_opts = function(desc)
    return { noremap = true, silent = true, desc = desc }
  end
  local fzf = require("fzf-lua")

  fzf.setup({ winopts = { preview = { layout = "vertical" } } })

  local args_small = { previewer = false, winopts = { height = 0.20, width = 0.80 } }
  vim.keymap.set("n", "<leader>ff", function()
    fzf.files(args_small)
  end, get_opts("Find files"))

  vim.keymap.set("n", "<leader>fb", function()
    fzf.buffers(args_small)
  end, get_opts("Find buffers"))
  vim.keymap.set("n", "<leader>fq", function()
    fzf.quickfix(args_small)
  end, get_opts("Find quickfix"))
  vim.keymap.set("n", "<leader>fl", function()
    fzf.loclist(args_small)
  end, get_opts("Find loclist"))

  vim.keymap.set("n", "<leader>ft", function()
    fzf.tabs(args_small)
  end, get_opts("Find tabs"))

  vim.keymap.set("n", "<leader>f", function() end, get_opts("Find..."))
  vim.keymap.set("n", "<leader>fc", fzf.commands, get_opts("Find commands"))
  vim.keymap.set("n", "<leader>fh", fzf.help_tags, get_opts("Find help"))
  vim.keymap.set("n", "<leader>fgp", fzf.live_grep_native, get_opts("Live grep"))
  vim.keymap.set("n", "<leader>fgb", fzf.grep_curbuf, get_opts("Grep current buffer"))

  vim.keymap.set("n", "<leader>fl", function() end, get_opts("Find LSP..."))
  vim.keymap.set("n", "<leader>flq", fzf.diagnostics_document, get_opts("Find document diagnostic"))
  vim.keymap.set("n", "<leader>flQ", fzf.diagnostics_workspace, get_opts("Find workspace diagnostic"))
  vim.keymap.set("n", "<leader>flr", fzf.lsp_references, get_opts("Find LSP references"))
  vim.keymap.set("n", "<leader>fls", fzf.lsp_document_symbols, get_opts("Find LSP document symbols"))
  vim.keymap.set("n", "<leader>flS", fzf.lsp_workspace_symbols, get_opts("Find LSP workspace symbols"))
  vim.keymap.set("n", "<leader>fli", fzf.lsp_implementations, get_opts("Find LSP implementations"))
  vim.keymap.set("n", "<leader>fld", fzf.lsp_definitions, get_opts("Find LSP definitions"))
  vim.keymap.set("n", "<leader>flD", fzf.lsp_declarations, get_opts("Find LSP declarations"))
  vim.keymap.set("n", "<leader>flt", fzf.lsp_typedefs, get_opts("Find LSP type defs"))

  vim.keymap.set("n", "<leader>fp", function()
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
  end, { silent = true, desc = "Switch project" })
end

return M
