local M = {}

M.setup = function()
  require("gitsigns").setup({
    signcolumn = true,
    numhl = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        local opts = {}
        opts.buffer = bufnr
        opts.desc = desc
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]g", function()
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      map("n", "[g", function()
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      -- Actions
      map({ "n", "v" }, "<leader>xh", function() end, "Git...")
      map({ "n", "v" }, "<leader>xhs", ":Gitsigns stage_hunk<CR>", "Git stage hunk")
      map({ "n", "v" }, "<leader>xhr", ":Gitsigns reset_hunk<CR>", "Git reset hunk")
      map("n", "<leader>xhS", gs.stage_buffer, "Git stage buffer")
      map("n", "<leader>xhu", gs.undo_stage_hunk, "Git undo stage hunk")
      map("n", "<leader>xhR", gs.reset_buffer, "Git reset buffer")
      map("n", "<leader>xhp", gs.preview_hunk, "Git preview hunk")
      map("n", "<leader>xhb", function()
        gs.blame_line({ full = true })
      end, "Git full line blame")
      map("n", "<leader>xhB", gs.toggle_current_line_blame, "Git toggle blame current line")
      map("n", "<leader>xhd", gs.diffthis, "Git diffthis")
      map("n", "<leader>xhD", function()
        gs.diffthis("~")
      end, "Git diffthis prev commit")
      map("n", "<leader>xhD", gs.toggle_deleted, "Git toggle delete")
      -- Text object
      map({ "o", "x" }, "xih", ":<C-U>Gitsigns select_hunk<CR>", "Git select hunk")
    end,
  })
end

return M
