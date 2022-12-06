local M = {}

local move_tbl = {
  top = "K",
  right = "L",
  bottom = "J",
  left = "H",
}

local bottom_panel = {
  winnr = nil,
  bufnr = nil,
  pos = nil,
  size = nil,
  augroup = nil,
  auto_scroll = false,
}

M.toggle_bottom_panel = function()
  local panel = bottom_panel

  if panel.winnr and not vim.api.nvim_win_is_valid(panel.winnr) then
    panel.winnr = nil
  end
  if panel.bufnr and not vim.api.nvim_buf_is_valid(panel.bufnr) then
    panel.bufnr = nil
  end

  if panel.winnr then
    pcall(vim.api.nvim_win_close, panel.winnr, true)
    vim.api.nvim_clear_autocmds({ group = panel.augroup })
    panel.winnr = nil
  else
    if panel.bufnr then
      vim.cmd("vsplit")
      vim.cmd("b" .. panel.bufnr)
      vim.fn.setpos(".", panel.pos)
    else
      vim.cmd("vnew")
    end

    local move_to = move_tbl.bottom
    vim.cmd("wincmd " .. move_to)
    vim.cmd("resize " .. tostring(panel.size or 10))
    vim.cmd("set winfixheight")

    panel.winnr = vim.api.nvim_get_current_win()
    panel.pos = vim.fn.getcurpos()

    if panel.auto_scroll then
      vim.cmd("normal! G")
    end

    panel.augroup = vim.api.nvim_create_augroup("PanelBottom", {})
    vim.api.nvim_create_autocmd("WinClosed", {
      group = panel.augroup,
      pattern = { tostring(panel.winnr) },
      callback = function()
        panel.bufnr = vim.fn.winbufnr(panel.winnr)
        panel.pos = vim.fn.getcurpos(panel.winnr)
        panel.size = vim.fn.winheight(panel.winnr)
        local mode = vim.fn.mode(1)
        local is_term = mode == "nt" or mode == "t"
        panel.auto_scroll = is_term and vim.fn.line(".") == vim.fn.line("$")
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
