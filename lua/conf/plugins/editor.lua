local env = require("conf.env")

return {
  {
    "echasnovski/mini.comment",
    opts = {},
  },

  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    keys = {
      {
        "<leader>up",
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            vim.notify("Disabled auto pairs")
          else
            vim.notify("Enabled auto pairs")
          end
        end,
        desc = "Toggle auto pairs",
      },
    },
    opts = {},
  },

  {
    "echasnovski/mini.surround",

    -- Taken from LazyVim.
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,

    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    enabled = env.NVIM_CMP ~= "off",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      vim.o.pumheight = 10

      local entries
      local performance
      if env.NVIM_CMP == "wildmenu" then
        entries = { name = "wildmenu", separator = " | " }
        performance = {
          debounce = 100,
          throttle = 100,
          max_view_entries = 10,
        }
      elseif env.NVIM_CMP == "menu" then
        entries = { native = true }
        performance = {
          max_view_entries = 10,
        }
      end

      return {
        performance = performance,
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          docs = {
            auto_open = false,
          },
          entries = entries,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-g>"] = function()
            if cmp.visible_docs() then
              cmp.close_docs()
            else
              cmp.open_docs()
            end
          end,
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = {
          { name = "nvim_lsp" },
        },
        formatting = {
          fields = { "abbr" },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      local compare = require("cmp.config.compare")

      cmp.setup(opts)
      cmp.setup.filetype({ "go" }, {
        -- preselect = "None", -- gopls preselects which annoys
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.order, -- gopls ordering is ok as it is
          },
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      -- Formatters are configured in plugins/lang/*
      formatters_by_ft = {},

      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.g.disable_autoformat = require("conf.env").NVIM_AUTOFORMAT == "off"

      vim.api.nvim_create_user_command("AutoformatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        if vim.g.disable_autoformat then
          vim.notify("Disabled auto formatting")
        else
          vim.notify("Enabled auto formatting")
        end
      end, {})
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    opts = {
      linters_by_ft = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      -- Linters are configured in plugins/lang/*
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
