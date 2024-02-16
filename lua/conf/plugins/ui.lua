local fzfUtil = require("conf.util.fzf")
local icons = require("conf.util.icons")

return {
  -- Dev icon support.
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "kyazdani42/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeFindFile",
    },
    opts = {
      view = {
        preserve_window_proportions = true,
        width = {
          min = 30,
          max = 120,
        },
        -- float = {
        --   enable = true,
        -- },
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

  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      columns = {
        -- "permissions",
        -- "size",
        -- "mtime",
      },
    },
  },

  {
    "echasnovski/mini.files",
    keys = {
      { "<leader>;", "<cmd>lua MiniFiles.open()<cr>", desc = "Files toggle" },
      { "<leader>'", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", desc = "Files find file" },
    },
    opts = {
      content = {
        prefix = function(fs_entry)
          if fs_entry.fs_type == "directory" then
            return icons.ui.ChevronShortRight .. " ", "MiniFilesDirectory"
          end
          return " ", "MiniFilesFile"
        end,
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      {
        "<leader>f",
        "<cmd>lua require('telescope.builtin').find_files({ file_ignore_patterns = { '^vendor/' } })<cr>",
        "Find files (filtered)",
      },
      {
        "<leader>F",
        "<cmd>lua require('telescope.builtin').find_files()<cr>",
        "Find files (all)",
      },
      {
        "<leader>g",
        "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
        "Live grep",
      },
      {
        "<leader>b",
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "Buffers",
      },
    },
    opts = function()
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").cycle_history_next,
              ["<C-k>"] = require("telescope.actions").cycle_history_prev,
              ["<C-p>"] = require("telescope-live-grep-args.actions").quote_prompt(),
            },
          },
        },
        pickers = {
          find_files = {
            disable_devicons = true,
          },
          buffers = {
            disable_devicons = true,
          },
          live_grep = {
            disable_devicons = true,
          },
        },
        extensions = {
          live_grep_args = {
            disable_devicons = true,
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("fzf")
    end,
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

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = false,
      },
    },
  },
}
