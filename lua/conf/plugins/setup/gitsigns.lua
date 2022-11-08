local M = {}

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local cmd_opts = {}
  local key_opts = {}

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

      bind_all("git.preview_hunk", gs.preview_hunk, cmd_opts, key_opts)
      bind_all("git.stage_hunk", ":Gitsigns stage_hunk<CR>", cmd_opts, key_opts)
      bind_all("git.unstage_hunk", gs.undo_stage_hunk, cmd_opts, key_opts)
      bind_all("git.reset_hunk", ":Gitsigns reset_hunk<CR>", cmd_opts, key_opts)
      bind_all("git.reset_buffer", gs.reset_buffer, cmd_opts, key_opts)
      bind_all("git.toggle_line_blame", gs.toggle_current_line_blame, cmd_opts, key_opts)
      bind_all("git.blame_line", function()
        gs.blame_line({ full = true })
      end, cmd_opts, key_opts)
      bind_all("git.toggle_show_deleted", gs.toggle_deleted, cmd_opts, key_opts)
      bind_all("git.diffthis", gs.diffthis, cmd_opts, key_opts)
      bind_all("git.diffthis_prev", function()
        gs.diffthis("~")
      end, cmd_opts, key_opts)
      bind_all("git.select_hunk", ":<C-U>Gitsigns select_hunk<CR>", cmd_opts, key_opts)
    end,
  })
end

return M
