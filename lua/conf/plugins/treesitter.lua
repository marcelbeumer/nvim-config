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
      if env.NVIM_SYNTAX == "off" then
        vim.cmd.syntax("off")
      end
    end,
    opts = {
      highlight = { enable = env.NVIM_SYNTAX == "on" },
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
          goto_next_start = {
            ["]f"] = "@function.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      vim.keymap.set("n", "[p", function()
        require("conf.util.treesitter").jump_to_parent_node()
      end, {})
      vim.keymap.set("n", "[i", function()
        require("conf.util.treesitter").jump_to_less_indented_line()
      end, {})
    end,
  },
}
