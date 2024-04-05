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

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local parse_bookmark = function(value)
        local filepath, row, col, postfix = string.match(value or "", "(.-):(%d+):(%d+)(.*)")

        if not filepath then
          -- We received a postfix or no value at all.
          -- Take information from current window.
          local pos = vim.api.nvim_win_get_cursor(0)
          filepath = require("conf.util.fs").file_path()
          row = pos[1]
          col = pos[2]
          postfix = value or ""
        end

        return {
          value = filepath .. ":" .. row .. ":" .. col .. postfix,
          filepath = filepath,
          row = tonumber(row),
          col = tonumber(col),
        }
      end

      return {
        bookmarks = {
          create_list_item = function(_, name)
            return { value = parse_bookmark(name).value }
          end,

          select = function(list_item, _, _)
            local bookmark = parse_bookmark(list_item.value)
            vim.cmd.edit(bookmark.filepath)
            vim.api.nvim_win_set_cursor(0, { bookmark.row, bookmark.col })
          end,
        },
      }
    end,

    keys = {
      {
        "<leader>a",
        function()
          local postfix = vim.fn.input("Note: ")
          if postfix ~= "" then
            postfix = " -- " .. postfix
          end
          local harpoon = require("harpoon")
          local bookmarks = harpoon:list("bookmarks")
          local item = bookmarks.config.create_list_item(bookmarks.config, postfix)
          bookmarks:prepend(item)
        end,
        desc = "Add bookmark",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list("bookmarks"), { title = "Bookmarks" })
        end,
        desc = "Show bookmarks",
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
