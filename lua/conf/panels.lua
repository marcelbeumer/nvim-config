local M = {}

local move_tbl = {
  left = "H",
  right = "L",
  bottom = "J",
}

local bottom_panel_winr = nil
local bottom_panel_bufnr = nil

M.toggle_bottom_panel = function()
  local winnr = bottom_panel_winr

  if not pcall(vim.api.nvim_win_get_number, bottom_panel_winr) then
    winnr = nil
  end

  if winnr then
    vim.fn.win_execute(winnr, "wincmd c")
    bottom_panel_winr = nil
  else
    vim.cmd("wincmd n")
    local move_to = move_tbl.bottom
    vim.cmd("wincmd " .. move_to)
    vim.cmd("resize 10")
    vim.cmd("set winfixheight")
    if bottom_panel_bufnr then
      vim.cmd("b" .. bottom_panel_bufnr)
    end
    bottom_panel_winr = vim.api.nvim_get_current_win()
    vim.api.nvim_create_autocmd("WinClosed", {
      pattern = { "" .. bottom_panel_winr },
      callback = function()
        bottom_panel_bufnr = vim.api.nvim_get_current_buf()
      end,
    })
  end
end

M.setup = function()
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local cmd_opts = {}
  local key_opts = { noremap = true, silent = true }

  bind_all("windows.toggle_bottom_panel", M.toggle_bottom_panel, cmd_opts, key_opts)
end

return M
