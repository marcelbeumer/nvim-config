return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    opts = {
      signcolumn = false,
      numhl = false,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        map("n", "<space>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<space>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<space>gS", gs.stage_buffer, "Stage buffer")
        map("v", "<space>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        --
        map("n", "<space>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<space>gR", gs.reset_buffer, "Reset buffer")
        map("v", "<space>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        --
        map("n", "<space>gp", gs.preview_hunk, "Preview Hunk")
        map("n", "<space>gb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<space>ghd", gs.diffthis, "Diff This")
        map("n", "<space>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")
      end,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>L", "<cmd>LazyGit<cr>", "Open lazygit" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
  },

  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    opts = {
      enabled = false,
    },
  },
}
