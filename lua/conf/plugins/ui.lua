local fzfUtil = require("conf.util.fzf")

return {
  -- Dev icon support.
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- File tree.
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<leader>;", "<cmd>NvimTreeToggle<cr>", desc = "Tree toggle" },
      { "<leader>'", "<cmd>NvimTreeFindFile<cr>", desc = "Tree find file" },
    },
    opts = {
      view = {
        preserve_window_proportions = true,
        width = {
          min = 30,
          max = 120,
        },
        float = {
          enable = true,
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = { error = "●", warning = "●", hint = "●", info = "●" },
      },
      live_filter = {
        always_show_folders = false,
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            folder = false,
            file = false,
          },
        },
      },
    },
  },

  -- Quick file/buffer/lsp/etc pickers.
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>f", fzfUtil.handler("files", fzfUtil.np_small), "Find files" },
      { "<leader>b", fzfUtil.handler("buffers", fzfUtil.np_large), "Find buffers" },
      { "<leader>q", fzfUtil.handler("quickfix", fzfUtil.np_large), "Find in quickfix" },
      { "<leader>Q", fzfUtil.handler("loclist", fzfUtil.np_large), "Find in loclist" },
      { "<leader>c", fzfUtil.handler("commands", fzfUtil.default), "Find command" },
      { "<leader>g", fzfUtil.handler("live_grep_resume", fzfUtil.default), "Find with ripgrep" },
      { "<leader>G", fzfUtil.handler("grep_curbuf", fzfUtil.default), "Find with ripgrep (buffer only)" },
      { "<leader>h", fzfUtil.handler("help_tags", fzfUtil.default), "Find in help" },
      { "<leader>lq", fzfUtil.handler("diagnostics_workspace", fzfUtil.default), "Find in diagnostics (workspace)" },
      { "<leader>lQ", fzfUtil.handler("diagnostics_document", fzfUtil.default), "Find in diagnostics (buffer)" },
      { "<leader>lr", fzfUtil.handler("lsp_references", fzfUtil.default), "Find in LSP references" },
      { "<leader>li", fzfUtil.handler("lsp_implementation", fzfUtil.default), "Find in LSP implementations" },
      { "<leader>ld", fzfUtil.handler("lsp_definitions", fzfUtil.default), "Find in LSP definitions" },
      { "<leader>lD", fzfUtil.handler("lsp_declarations", fzfUtil.default), "Find in LSP declarations" },
      { "<leader>lt", fzfUtil.handler("lsp_typedefs", fzfUtil.default), "Find in LSP typedefs" },
      { "<leader>ls", fzfUtil.handler("lsp_workspace_symbols", fzfUtil.default), "Find in LSP symbols (workspace)" },
      { "<leader>lS", fzfUtil.handler("lsp_document_symbols", fzfUtil.default), "Find in LSP symbols (buffer)" },
    },
    opts = {
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
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<leader>/", "<cmd>SymbolsOutline<cr>", "Symbols outline toggle" },
    },
    opts = {},
  },

  -- File bookmark/picker.
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<C-.>", [[<cmd>lua require("harpoon.ui").nav_next()<cr>]], "Harpoon next" },
      { "<C-,>", [[<cmd>lua require("harpoon.ui").nav_prev()<cr>]], "Harpoon prev" },
      { "<leader>p", [[<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>]], "Harpoon quick menu" },
      { "<leader>a", [[<cmd>lua require("harpoon.mark").add_file()<cr>]], "Harpoon add file" },
      { "<leader>d", [[<cmd>lua require("harpoon.mark").rm_file()<cr>]], "Harpoon remove file" },
      { "<leader>1", [[<cmd>lua require("harpoon.term").gotoTerminal(1)<cr>]], "Harpoon terminal #1" },
      { "<leader>2", [[<cmd>lua require("harpoon.term").gotoTerminal(2)<cr>]], "Harpoon terminal #2" },
      { "<leader>3", [[<cmd>lua require("harpoon.term").gotoTerminal(3)<cr>]], "Harpoon terminal #3" },
    },
    opts = {
      menu = {
        width = 120,
        height = 20,
      },
    },
  },

  -- See which key bindings work.
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        spelling = {
          enabled = true,
        },
      },
    },
    init = function()
      vim.o.timeoutlen = 500
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", "Trouble toggle" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble workspace diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble buffer diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", "Trouble loclist" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", "Trouble quickfix" },
      { "<leader>xlr", "<cmd>TroubleToggle lsp_references<cr>", "Trouble LSP references" },
      { "<leader>xli", "<cmd>TroubleToggle lsp_implementations<cr>", "Trouble LSP implementations" },
      { "<leader>xld", "<cmd>TroubleToggle lsp_definitions<cr>", "Trouble LSP definitions" },
      { "<leader>xlt", "<cmd>TroubleToggle lsp_type_definitions<cr>", "Trouble LSP type definitions" },
    },
    opts = {},
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Spectre", "Spectre" },
    opts = {},
  },
}
