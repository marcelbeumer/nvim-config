-- Inspired by https://github.com/habamax/vim-winlayout/tree/2bb3aa5a749abe887a15fae9d14201d125d0c7e6
local M = {}

local last_state = nil

local function get_buffers(layout, buffers, winstate)
  local type = layout[1]
  local value = layout[2]
  if type == "leaf" then
    local win = vim.fn.getwininfo(value)
    local fixw = vim.fn.getwinvar(value, "&winfixwidth")
    local fixh = vim.fn.getwinvar(value, "&winfixheight")
    if win and win[1] then
      buffers[value] = win[1].bufnr
    end
    local cursor = vim.api.nvim_win_get_cursor(value)
    winstate[value] = {
      topline = win.topline,
      lnum = cursor[1],
      col = cursor[2],
      fixw = fixw,
      fixh = fixh,
    }
  else
    for _, v in ipairs(value) do
      get_buffers(v, buffers, winstate)
    end
  end
end

local function rebuild_layout(layout, buffers, winstate)
  local type = layout[1]
  local value = layout[2]
  if type == "leaf" then
    local bufnr = buffers[value]
    vim.fn.setwinvar(0, "&winfixwidth", winstate[value].fixw)
    vim.fn.setwinvar(0, "&winfixheight", winstate[value].fixh)

    if vim.fn.bufexists(bufnr) then
      vim.cmd("b " .. bufnr)
      vim.fn.winrestview({
        lnum = winstate[value].lnum,
        col = winstate[value].col,
        -- FIXME: jumping back to entirely correct when not active window?
        topline = winstate[value].topline,
      })
    end
  else
    local split_method = type == "col" and "rightbelow split" or "rightbelow vsplit"

    -- create splits and record window ids
    local wins = { vim.fn.win_getid() }
    for i, _ in ipairs(value) do
      if i > 1 then
        vim.cmd(split_method)
        table.insert(wins, vim.fn.win_getid())
      end
    end

    -- for each window id go recursive
    for i, v in ipairs(wins) do
      vim.fn.win_gotoid(v)
      local sub_layout = value[i]
      rebuild_layout(sub_layout, buffers, winstate)
    end
  end
end

M.save = function()
  local restcmd = vim.fn.winrestcmd()
  local layout = vim.fn.winlayout()
  local winnr = vim.fn.winnr()
  local winstate = {}
  local buffers = {}
  get_buffers(layout, buffers, winstate)
  last_state = {
    winnr = winnr,
    layout = layout,
    buffers = buffers,
    winstate = winstate,
    restcmd = restcmd,
  }
  vim.notify("Window layout saved.")
end

M.restore = function()
  if last_state then
    -- TODO: before restoring, quickly run through all windows that might still exist (by id)
    -- and update the winstate if they are still running the same buffer.
    vim.cmd.wincmd("o")
    rebuild_layout(last_state.layout, last_state.buffers, last_state.winstate)
    vim.cmd(last_state.restcmd)
    vim.cmd(last_state.winnr .. "wincmd w")
    vim.notify("Window layout restored.")
  else
    vim.notify("No window layout saved.")
  end
end

M.setup = function()
  local bindings = require("conf.bindings")
  local key_opts = {}
  local cmd_opts = {}

  bindings.bind_all("layout.save", M.save, cmd_opts, key_opts)
  bindings.bind_all("layout.restore", M.restore, cmd_opts, key_opts)
end

-- M.save()
-- M.restore()

return M
