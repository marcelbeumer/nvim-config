local fzfUtil = require("conf.util.fzf")
local icons = require("conf.util.icons")

return {
  -- Dev icon support.
  { "nvim-tree/nvim-web-devicons", lazy = true },

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

  -- {
  --   "folke/snacks.nvim",
  --   opts = {
  --     picker = {
  --       icons = {},
  --       layout = {
  --         preview = "none",
  --         preset = "ivy",
  --       },
  --     },
  --   },
  --   keys = {
  --     -- Top Pickers & Explorer
  --     {
  --       "<leader><space>",
  --       function()
  --         Snacks.picker.smart()
  --       end,
  --       desc = "Smart Find Files",
  --     },
  --     {
  --       "<leader>,",
  --       function()
  --         Snacks.picker.buffers()
  --       end,
  --       desc = "Buffers",
  --     },
  --     {
  --       "<leader>/",
  --       function()
  --         Snacks.picker.grep()
  --       end,
  --       desc = "Grep",
  --     },
  --     {
  --       "<leader>:",
  --       function()
  --         Snacks.picker.command_history()
  --       end,
  --       desc = "Command History",
  --     },
  --     {
  --       "<leader>n",
  --       function()
  --         Snacks.picker.notifications()
  --       end,
  --       desc = "Notification History",
  --     },
  --     {
  --       "<leader>e",
  --       function()
  --         Snacks.explorer()
  --       end,
  --       desc = "File Explorer",
  --     },
  --     -- find
  --     {
  --       "<leader>fb",
  --       function()
  --         Snacks.picker.buffers()
  --       end,
  --       desc = "Buffers",
  --     },
  --     {
  --       "<leader>fc",
  --       function()
  --         Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
  --       end,
  --       desc = "Find Config File",
  --     },
  --     {
  --       "<leader>ff",
  --       function()
  --         Snacks.picker.files()
  --       end,
  --       desc = "Find Files",
  --     },
  --     {
  --       "<leader>fg",
  --       function()
  --         Snacks.picker.git_files()
  --       end,
  --       desc = "Find Git Files",
  --     },
  --     {
  --       "<leader>fp",
  --       function()
  --         Snacks.picker.projects()
  --       end,
  --       desc = "Projects",
  --     },
  --     {
  --       "<leader>fr",
  --       function()
  --         Snacks.picker.recent()
  --       end,
  --       desc = "Recent",
  --     },
  --     -- git
  --     {
  --       "<leader>gb",
  --       function()
  --         Snacks.picker.git_branches()
  --       end,
  --       desc = "Git Branches",
  --     },
  --     {
  --       "<leader>gl",
  --       function()
  --         Snacks.picker.git_log()
  --       end,
  --       desc = "Git Log",
  --     },
  --     {
  --       "<leader>gL",
  --       function()
  --         Snacks.picker.git_log_line()
  --       end,
  --       desc = "Git Log Line",
  --     },
  --     {
  --       "<leader>gs",
  --       function()
  --         Snacks.picker.git_status()
  --       end,
  --       desc = "Git Status",
  --     },
  --     {
  --       "<leader>gS",
  --       function()
  --         Snacks.picker.git_stash()
  --       end,
  --       desc = "Git Stash",
  --     },
  --     {
  --       "<leader>gd",
  --       function()
  --         Snacks.picker.git_diff()
  --       end,
  --       desc = "Git Diff (Hunks)",
  --     },
  --     {
  --       "<leader>gf",
  --       function()
  --         Snacks.picker.git_log_file()
  --       end,
  --       desc = "Git Log File",
  --     },
  --     -- Grep
  --     {
  --       "<leader>sb",
  --       function()
  --         Snacks.picker.lines()
  --       end,
  --       desc = "Buffer Lines",
  --     },
  --     {
  --       "<leader>sB",
  --       function()
  --         Snacks.picker.grep_buffers()
  --       end,
  --       desc = "Grep Open Buffers",
  --     },
  --     {
  --       "<leader>sg",
  --       function()
  --         Snacks.picker.grep()
  --       end,
  --       desc = "Grep",
  --     },
  --     {
  --       "<leader>sw",
  --       function()
  --         Snacks.picker.grep_word()
  --       end,
  --       desc = "Visual selection or word",
  --       mode = { "n", "x" },
  --     },
  --     -- search
  --     {
  --       '<leader>s"',
  --       function()
  --         Snacks.picker.registers()
  --       end,
  --       desc = "Registers",
  --     },
  --     {
  --       "<leader>s/",
  --       function()
  --         Snacks.picker.search_history()
  --       end,
  --       desc = "Search History",
  --     },
  --     {
  --       "<leader>sa",
  --       function()
  --         Snacks.picker.autocmds()
  --       end,
  --       desc = "Autocmds",
  --     },
  --     {
  --       "<leader>sb",
  --       function()
  --         Snacks.picker.lines()
  --       end,
  --       desc = "Buffer Lines",
  --     },
  --     {
  --       "<leader>sc",
  --       function()
  --         Snacks.picker.command_history()
  --       end,
  --       desc = "Command History",
  --     },
  --     {
  --       "<leader>sC",
  --       function()
  --         Snacks.picker.commands()
  --       end,
  --       desc = "Commands",
  --     },
  --     {
  --       "<leader>sd",
  --       function()
  --         Snacks.picker.diagnostics()
  --       end,
  --       desc = "Diagnostics",
  --     },
  --     {
  --       "<leader>sD",
  --       function()
  --         Snacks.picker.diagnostics_buffer()
  --       end,
  --       desc = "Buffer Diagnostics",
  --     },
  --     {
  --       "<leader>sh",
  --       function()
  --         Snacks.picker.help()
  --       end,
  --       desc = "Help Pages",
  --     },
  --     {
  --       "<leader>sH",
  --       function()
  --         Snacks.picker.highlights()
  --       end,
  --       desc = "Highlights",
  --     },
  --     {
  --       "<leader>si",
  --       function()
  --         Snacks.picker.icons()
  --       end,
  --       desc = "Icons",
  --     },
  --     {
  --       "<leader>sj",
  --       function()
  --         Snacks.picker.jumps()
  --       end,
  --       desc = "Jumps",
  --     },
  --     {
  --       "<leader>sk",
  --       function()
  --         Snacks.picker.keymaps()
  --       end,
  --       desc = "Keymaps",
  --     },
  --     {
  --       "<leader>sl",
  --       function()
  --         Snacks.picker.loclist()
  --       end,
  --       desc = "Location List",
  --     },
  --     {
  --       "<leader>sm",
  --       function()
  --         Snacks.picker.marks()
  --       end,
  --       desc = "Marks",
  --     },
  --     {
  --       "<leader>sM",
  --       function()
  --         Snacks.picker.man()
  --       end,
  --       desc = "Man Pages",
  --     },
  --     {
  --       "<leader>sp",
  --       function()
  --         Snacks.picker.lazy()
  --       end,
  --       desc = "Search for Plugin Spec",
  --     },
  --     {
  --       "<leader>sq",
  --       function()
  --         Snacks.picker.qflist()
  --       end,
  --       desc = "Quickfix List",
  --     },
  --     {
  --       "<leader>sR",
  --       function()
  --         Snacks.picker.resume()
  --       end,
  --       desc = "Resume",
  --     },
  --     {
  --       "<leader>su",
  --       function()
  --         Snacks.picker.undo()
  --       end,
  --       desc = "Undo History",
  --     },
  --     {
  --       "<leader>uC",
  --       function()
  --         Snacks.picker.colorschemes()
  --       end,
  --       desc = "Colorschemes",
  --     },
  --     -- LSP
  --     {
  --       "gd",
  --       function()
  --         Snacks.picker.lsp_definitions()
  --       end,
  --       desc = "Goto Definition",
  --     },
  --     {
  --       "gD",
  --       function()
  --         Snacks.picker.lsp_declarations()
  --       end,
  --       desc = "Goto Declaration",
  --     },
  --     {
  --       "gr",
  --       function()
  --         Snacks.picker.lsp_references()
  --       end,
  --       nowait = true,
  --       desc = "References",
  --     },
  --     {
  --       "gI",
  --       function()
  --         Snacks.picker.lsp_implementations()
  --       end,
  --       desc = "Goto Implementation",
  --     },
  --     {
  --       "gy",
  --       function()
  --         Snacks.picker.lsp_type_definitions()
  --       end,
  --       desc = "Goto T[y]pe Definition",
  --     },
  --     {
  --       "<leader>ss",
  --       function()
  --         Snacks.picker.lsp_symbols()
  --       end,
  --       desc = "LSP Symbols",
  --     },
  --     {
  --       "<leader>sS",
  --       function()
  --         Snacks.picker.lsp_workspace_symbols()
  --       end,
  --       desc = "LSP Workspace Symbols",
  --     },
  --   },
  -- },

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
            follow = true,
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
