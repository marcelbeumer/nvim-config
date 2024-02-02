if vim.g.neovide then
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_window_blurred = false
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_transparency = 1.0
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  -- vim.g.neovide_unlink_border_highlights = true
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_cursor_animate_command_line = false
  vim.o.guifont = "JetBrainsMonoNL Nerd Font:h13:w-1"

  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(0.1)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(-0.1)
  end)
end
