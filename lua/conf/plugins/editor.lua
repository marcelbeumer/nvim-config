return {
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("mini.pairs").setup(opts)
      vim.api.nvim_create_user_command("AutopairsToggle", function()
        vim.g.minipairs_disable = not vim.g.minipairs_disable
        if vim.g.minipairs_disable then
          vim.notify("Disabled autopairs")
        else
          vim.notify("Enabled autopairs")
        end
      end, {})
    end,
  },

  {
    "echasnovski/mini.surround",
    keys = { "s" },
    opts = {},
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
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
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
