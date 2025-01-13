local env = require("conf.env")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
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
    },
    config = function(_, opts)
      if env.NVIM_TREESITTER == "on" then
        require("nvim-treesitter.configs").setup(opts)
      end
    end,
  },
}
