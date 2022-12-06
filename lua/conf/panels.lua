local M = {}

local panels = {
  top = {
    winnr = nil,
    bufnr = nil,
    pos = nil,
    size = nil,
    augroup = nil,
    auto_scroll = false,
    default_size = 10,
    wincmd_dir = "K",
    fix_dim_cmd = "set winfixheight",
    resize_cmd = "resize",
    get_size = function(winnr)
      return vim.fn.winheight(winnr)
    end,
  },
  right = {
    winnr = nil,
    bufnr = nil,
    pos = nil,
    size = nil,
    augroup = nil,
    auto_scroll = false,
    default_size = 80,
    wincmd_dir = "L",
    fix_dim_cmd = "set winfixwidth",
    resize_cmd = "vertical resize",
    get_size = function(winnr)
      return vim.fn.winwidth(winnr)
    end,
  },
  bottom = {
    winnr = nil,
    bufnr = nil,
    pos = nil,
    size = nil,
    augroup = nil,
    auto_scroll = false,
    default_size = 10,
    wincmd_dir = "J",
    fix_dim_cmd = "set winfixheight",
    resize_cmd = "resize",
    get_size = function(winnr)
      return vim.fn.winheight(winnr)
    end,
  },
}

M.toggle_panel = function(side)
  local panel = panels[side]
  if not panel then
    return
  end

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

    vim.cmd("wincmd " .. panel.wincmd_dir)
    vim.cmd(panel.resize_cmd .. tostring(panel.size or panel.default_size))
    vim.cmd(panel.fix_dim_cmd)

    panel.winnr = vim.api.nvim_get_current_win()
    panel.pos = vim.fn.getcurpos()

    if panel.auto_scroll then
      vim.cmd("normal! G")
    end

    panel.augroup = vim.api.nvim_create_augroup("Panel" .. side, {})
    vim.api.nvim_create_autocmd("WinClosed", {
      group = panel.augroup,
      pattern = { tostring(panel.winnr) },
      callback = function()
        panel.bufnr = vim.fn.winbufnr(panel.winnr)
        panel.pos = vim.fn.getcurpos(panel.winnr)
        panel.size = panel.get_size(panel.winnr)
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

  bind_all("windows.toggle_bottom_panel", function()
    M.toggle_panel("bottom")
  end, cmd_opts, key_opts)

  bind_all("windows.toggle_right_panel", function()
    M.toggle_panel("right")
  end, cmd_opts, key_opts)

  bind_all("windows.toggle_top_panel", function()
    M.toggle_panel("top")
  end, cmd_opts, key_opts)
end

return M
