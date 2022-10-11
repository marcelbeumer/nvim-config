local M = {}

M.setup = function()
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")

  telescope.setup({
    defaults = {
      jump_type = "never",
      ignore_entry_widths = true,
      overide_entry_separators = ":",
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        vertical = {
          mirror = true,
          anchor = "N",
          prompt_position = "top",
          width = 0.7,
          height = 0.9,
        },
      },
    },
    pickers = {
      find_files = {
        disable_devicons = true,
        previewer = false,
        layout_config = {
          height = 20,
        },
      },
      live_grep = {
        disable_devicons = true,
      },
    },
  })

  telescope.load_extension("fzf")

  local get_opts = function(desc)
    return { noremap = true, silent = true, desc = desc }
  end

  vim.keymap.set("n", "<leader>f", function() end, get_opts("Find..."))
  vim.keymap.set("n", "<leader>ff", function()
    builtin.find_files({ follow = true })
  end, get_opts("Find files"))
  vim.keymap.set("n", "<leader>fF", function()
    builtin.find_files({ follow = true, hidden = true, no_ignore = true })
  end, get_opts("Find files"))
  vim.keymap.set("n", "<leader>fb", builtin.buffers, get_opts("Find buffers"))
  vim.keymap.set("n", "<leader>fq", builtin.quickfix, get_opts("Find quickfix"))
  vim.keymap.set("n", "<leader>fq", builtin.loclist, get_opts("Find loclist"))

  vim.keymap.set("n", "<leader>fc", builtin.commands, get_opts("Find commands"))
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, get_opts("Find help"))
  vim.keymap.set("n", "<leader>fgp", builtin.live_grep, get_opts("Live grep"))
  vim.keymap.set("n", "<leader>fgb", builtin.current_buffer_fuzzy_find, get_opts("Grep current buffer"))

  vim.keymap.set("n", "<leader>fl", function() end, get_opts("Find LSP..."))

  vim.keymap.set("n", "<leader>flq", function()
    builtin.diagnostics({ bufnr = 0, jump_type = "never" })
  end, get_opts("Find document diagnostic"))

  vim.keymap.set("n", "<leader>flQ", function()
    builtin.diagnostics({ jump_type = "never" })
  end, get_opts("Find workspace diagnostic"))

  vim.keymap.set("n", "<leader>flr", function()
    builtin.lsp_references({ jump_type = "never" })
  end, get_opts("Find LSP references"))

  vim.keymap.set("n", "<leader>fls", function()
    builtin.lsp_document_symbols({ jump_type = "never" })
  end, get_opts("Find LSP document symbols"))

  vim.keymap.set("n", "<leader>flS", function()
    builtin.lsp_workspace_symbols({ jump_type = "never" })
  end, get_opts("Find LSP workspace symbols"))

  vim.keymap.set("n", "<leader>fli", function()
    builtin.lsp_implementations({ jump_type = "never" })
  end, get_opts("Find LSP implementations"))

  vim.keymap.set("n", "<leader>fld", function()
    builtin.lsp_definitions({ jump_type = "never" })
  end, get_opts("Find LSP definitions"))

  vim.keymap.set("n", "<leader>flt", function()
    builtin.lsp_type_definitions({ jump_type = "never" })
  end, get_opts("Find LSP type defs"))
end

return M
