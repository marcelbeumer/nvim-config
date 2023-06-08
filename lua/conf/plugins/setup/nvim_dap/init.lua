local Path = require("plenary.path")

local M = {}

local lang_modules = {
  "conf.plugins.setup.nvim_dap.lang.go",
  "conf.plugins.setup.nvim_dap.lang.typescript",
}

local setup_languages = function()
  for _, mod in ipairs(lang_modules) do
    require(mod).setup()
  end
end

local reset_configurations = function()
  local dap = require("dap")
  for _, mod in ipairs(lang_modules) do
    local configurations = require(mod).configurations()
    dap.configurations = vim.tbl_extend("force", dap.configurations, configurations)
  end
end

local get_launch_lua_basedir = function()
  local data_path = vim.fn.stdpath("data")
  return string.format("%s%s%s", data_path, "/nvim-dap-launch-lua", vim.fn.getcwd())
end

local get_launch_lua_path = function()
  return string.format("%s/launch.lua", get_launch_lua_basedir())
end

local make_launch_lua = function()
  vim.fn.system("mkdir -p " .. get_launch_lua_basedir())
  local p = Path:new(get_launch_lua_path())
  if not p:exists() then
    p:write(
      [[
local nvim_dap = require("conf.plugins.setup.nvim_dap")

return {
	go = {
		{
			type = "go",
			name = "App (with args)",
			request = "launch",
			cwd = ".",
			program = "./main.go",
			args = nvim_dap.prompt_array_fn("args: "),
		},
		{
			type = "go",
			name = "App subcommand",
			request = "launch",
			cwd = ".",
			program = "./main.go",
			args = { "subcommand" },
		},
	},
}
    ]],
      "w"
    )
  end
end

local launch_lua_mtime = nil

local load_launch_lua = function()
  local dap = require("dap")

  local stat = vim.loop.fs_stat(get_launch_lua_path())
  if stat == nil then
    return
  end

  local last = launch_lua_mtime
  local mtime = stat.mtime
  if last and mtime.sec == last.sec and mtime.nsec == last.nsec then
    return
  end
  launch_lua_mtime = mtime

  local config = {}
  pcall(function()
    config = loadfile(get_launch_lua_path())()
  end)

  reset_configurations()
  for lang, lang_confs in pairs(config) do
    for _, conf in ipairs(lang_confs) do
      if not dap.configurations[lang] then
        dap.configurations[lang] = {}
      end
      table.insert(dap.configurations[lang], conf)
    end
  end
end

M.prompt_array_fn = function(prompt, default)
  local lastargs = default
  return function()
    return coroutine.create(function(co)
      vim.ui.input({ prompt = prompt, default = lastargs }, function(args)
        lastargs = args or ""
        coroutine.resume(co, vim.split(lastargs, " "))
      end)
    end)
  end
end

M.prompt_string_fn = function(prompt)
  local lastargs = nil
  return function()
    return coroutine.create(function(co)
      vim.ui.input({ prompt = prompt, default = lastargs }, function(args)
        lastargs = args or ""
        coroutine.resume(co, lastargs)
      end)
    end)
  end
end

M.setup = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local icons = require("conf.icons")
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  setup_languages()
  reset_configurations()

  dapui.setup({})

  -- Inspired by LunarVim
  vim.fn.sign_define("DapBreakpoint", {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })
  vim.fn.sign_define("DapBreakpointRejected", {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })
  vim.fn.sign_define("DapStopped", {
    text = icons.ui.Bug,
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })

  -- require("nvim-dap-virtual-text").setup({})

  bind_all("dap.launch_lua_edit", function()
    make_launch_lua()
    vim.cmd.edit(get_launch_lua_path())
  end, {}, key_opts)
  bind_all("dap.ui_toggle_all", function()
    dapui.toggle()
  end, {}, key_opts)
  bind_all("dap.ui_toggle_sidebar", function()
    dapui.toggle(1)
  end, {}, key_opts)
  bind_all("dap.ui_toggle_tray", function()
    dapui.toggle(2)
  end, {}, key_opts)
  bind_all("dap.continue", function()
    load_launch_lua()
    dap.continue()
  end, {}, key_opts)
  bind_all("dap.terminate", function()
    dap.terminate()
  end, {}, key_opts)
  bind_all("dap.step_over", function()
    dap.step_over()
  end, {}, key_opts)
  bind_all("dap.step_into", function()
    dap.step_into()
  end, {}, key_opts)
  bind_all("dap.step_out", function()
    dap.step_out()
  end, {}, key_opts)
  bind_all("dap.toggle_breakpoint", function()
    dap.toggle_breakpoint()
  end, {}, key_opts)
  bind_all("dap.clear_breakpoints", function()
    dap.clear_breakpoints()
  end, {}, key_opts)
  bind_all("dap.breakpoint_condition", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, {}, key_opts)
  bind_all("dap.breakpoint_log", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, {}, key_opts)
  bind_all("dap.repl_toggle", function()
    dap.repl.toggle()
  end, {}, key_opts)
  bind_all("dap.run_last", function()
    dap.run_last()
  end, {}, key_opts)
  bind_all("dap.eval", dapui.eval, {}, key_opts)
end

return M
