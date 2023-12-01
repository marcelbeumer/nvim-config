local env = require("conf.env")

return {
  -- Based on LazyVim.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldlevel = 99
      if env.NVIM_SYNTAX_HIGHLIGHT == "off" then
        vim.cmd.syntax("off")
      end
    end,
    opts = {
      highlight = { enable = env.NVIM_SYNTAX_HIGHLIGHT == "on" },
      indent = { enable = false },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "go",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          -- goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          -- goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          -- goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          -- goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          goto_next_start = { ["]f"] = "@function.outer" },
          goto_next_end = { ["]F"] = "@function.outer" },
          goto_previous_start = { ["[f"] = "@function.outer" },
          goto_previous_end = { ["[F"] = "@function.outer" },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context of the current function
  -- TOOD: use keys from bindings
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { mode = "cursor", max_lines = 3 },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}
