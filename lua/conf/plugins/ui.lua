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
      { "<leader>li", fzfUtil.handler("lsp_implementations", fzfUtil.default), "Find in LSP implementations" },
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
  -- What I would really like w/ harpoon2 is to have a window like:
  --   path/to/file:23:2 // some comment
  --   path/to/file:23:2 -- some comment
  --   path/to/file:23:2 # some comment
  --   # Comment block not a file at all
  --   // Comment block not a file at all
  --   -- Comment block not a file at all
  --   path/to/file:1:1
  -- And remember the last position in the harpoon UI too.
  -- And be able to open all files/pos into the quickfix list, for this I want to get the code on the current line and store it too.
  -- This way I would have a true bookmarking system where I can also make notes.
  {
    "marcelbeumer/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>p",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list("bookmarks"))
        end,
        "Harpoon quick menu",
      },
      {
        "<leader>a",
        function()
          local harpoon = require("harpoon")
          harpoon:list("bookmarks"):append()
        end,
        "Harpoon add file",
      },
      {
        "<leader>d",
        function()
          local harpoon = require("harpoon")
          harpoon:list("bookmarks"):remove()
        end,
        "Harpoon prev",
      },
      {
        "<C-.>",
        function()
          local harpoon = require("harpoon")
          harpoon:list("bookmarks"):next()
        end,
        "Harpoon next",
      },
      {
        "<C-,>",
        function()
          local harpoon = require("harpoon")
          harpoon:list("bookmarks"):prev()
        end,
        "Harpoon prev",
      },
    },
    opts = {
      bookmarks = {
        select = function(list_item, _, options)
          options = options or {}
          if list_item == nil then
            return
          end

          local pattern = "(.-):(%d+):(%d+)"
          local path, row, col = list_item.value:match(pattern)

          local bufnr = vim.fn.bufnr(path)
          if bufnr == -1 then
            bufnr = vim.fn.bufnr(path, true)
          end

          vim.api.nvim_set_current_buf(bufnr)
          vim.api.nvim_win_set_cursor(0, {
            row and tonumber(row) or 1,
            col and tonumber(col) or 0,
          })
        end,

        create_list_item = function(config, name)
          -- TODO: should support comment parsing
          if name then
            return { value = name }
          end

          local Path = require("plenary.path")
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
          local root = config.get_root_dir()
          name = Path:new(bufname):make_relative(root)
          local bufnr = vim.fn.bufnr(name, false)

          local pos = { 1, 0 }
          if bufnr ~= -1 then
            pos = vim.api.nvim_win_get_cursor(0)
          end

          local value = name .. ":" .. pos[1] .. ":" .. pos[2]
          return { value = value }
        end,

        BufLeave = function() end,
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
    dependencies = {
      "junegunn/fzf",
    },
    ft = "qf",
    setup = function(_, opts)
      vim.fn["fzf#install"]()
    end,
  },
}
