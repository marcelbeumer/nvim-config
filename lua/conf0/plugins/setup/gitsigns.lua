local M = {}

M.setup = function()
  local bind_all = require("conf0.bindings").bind_all

  require("gitsigns").setup({
    signcolumn = true,
    numhl = true,
    on_attach = function()
      local gs = package.loaded.gitsigns

      bind_all("git.next_hunk", function()
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, {}, { expr = true })

      bind_all("git.prev_hunk", function()
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, {}, { expr = true })

      bind_all("git.preview_hunk", gs.preview_hunk, {}, {})
      bind_all("git.stage_hunk", ":Gitsigns stage_hunk<CR>", {}, {})
      bind_all("git.unstage_hunk", gs.undo_stage_hunk, {}, {})
      bind_all("git.reset_hunk", ":Gitsigns reset_hunk<CR>", {}, {})
      bind_all("git.reset_buffer", gs.reset_buffer, {}, {})
      bind_all("git.toggle_line_blame", gs.toggle_current_line_blame, {}, {})
      bind_all("git.blame_line", function()
        gs.blame_line({ full = true })
      end, {}, {})
      bind_all("git.toggle_show_deleted", gs.toggle_deleted, {}, {})
      bind_all("git.diffthis", gs.diffthis, {}, {})
      bind_all("git.diffthis_prev", function()
        gs.diffthis("~")
      end, {}, {})
      bind_all("git.select_hunk", ":<C-U>Gitsigns select_hunk<CR>", {}, {})
    end,
  })
end

return M
