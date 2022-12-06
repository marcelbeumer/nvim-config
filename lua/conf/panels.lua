local M = {}

local default_sizes = {
  j = 10,
  k = 10,
  l = 80,
}

local create_panel = function(direction)
  return {
    winnr = nil,
    bufnr = nil,
    pos = nil,
    size = nil,
    augroup = nil,
    auto_scroll = false,
    direction = direction,
  }
end

local panels = {}

M.toggle_panel = function(direction)
  local current_tab = vim.api.nvim_get_current_tabpage()

  if not panels[current_tab] then
    panels[current_tab] = {}
  end

  if not panels[current_tab][direction] then
    panels[current_tab][direction] = create_panel(direction)
  end

  local panel = panels[current_tab][direction]

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

    vim.cmd("wincmd " .. string.upper(panel.direction))

    local size = tostring(panel.size or default_sizes[panel.direction])
    if panel.direction == "j" or panel.direction == "k" then
      vim.cmd("set winfixheight")
      vim.cmd("resize" .. size)
    else
      vim.cmd("set winfixwidth")
      vim.cmd("vertical resize" .. size)
    end

    panel.winnr = vim.api.nvim_get_current_win()
    panel.pos = vim.fn.getcurpos()

    if panel.auto_scroll then
      vim.cmd("normal! G")
    end

    panel.augroup = vim.api.nvim_create_augroup("Panel__" .. current_tab .. "__" .. direction, {})
    vim.api.nvim_create_autocmd("WinClosed", {
      group = panel.augroup,
      pattern = { tostring(panel.winnr) },
      callback = function()
        panel.bufnr = vim.fn.winbufnr(panel.winnr)
        panel.pos = vim.fn.getcurpos(panel.winnr)
        if panel.direction == "j" or panel.direction == "k" then
          panel.size = vim.fn.winheight(panel.winnr)
        else
          panel.size = vim.fn.winwidth(panel.winnr)
        end

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

  bind_all("panels.toggle_bottom", function()
    M.toggle_panel("j")
  end, cmd_opts, key_opts)

  bind_all("panels.toggle_right", function()
    M.toggle_panel("l")
  end, cmd_opts, key_opts)

  bind_all("panels.toggle_top", function()
    M.toggle_panel("k")
  end, cmd_opts, key_opts)
end

return M
