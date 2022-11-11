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

local get_launch_json_basedir = function()
  local data_path = vim.fn.stdpath("data")
  return string.format("%s%s%s", data_path, "/conf-nvim-dap", vim.fn.getcwd())
end

local get_launch_json_path = function()
  return string.format("%s/dap-launch.json", get_launch_json_basedir())
end

local make_launch_json = function()
  vim.fn.system("mkdir -p " .. get_launch_json_basedir())
  local p = Path:new(get_launch_json_path())
  if not p:exists() then
    p:write(
      vim.fn.json_encode({
        lang = {
          {
            type = "lang",
            name = "Example (file)",
            request = "launch",
            program = "${file}",
          },
        },
      }),
      "w"
    )
  end
end

local load_launch_json = function()
  local dap = require("dap")
  local p = Path:new(get_launch_json_path())
  if not p:exists() then
    return
  end

  reset_configurations()
  local config = vim.fn.json_decode(p:read())

  for lang, lang_confs in pairs(config) do
    for _, conf in ipairs(lang_confs) do
      if not dap.configurations[lang] then
        dap.configurations[lang] = {}
      end
      table.insert(dap.configurations[lang], conf)
    end
  end
end

M.setup = function()
  local dap = require("dap")
  local dapui = require("dapui")
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  setup_languages()
  reset_configurations()
  dapui.setup()
  require("nvim-dap-virtual-text").setup({})

  bind_all("dap.launch_json_edit", function()
    make_launch_json()
    vim.cmd.edit(get_launch_json_path())
  end, cmd_opts, key_opts)
  bind_all("dap.ui_toggle_all", function()
    dapui.toggle()
  end, cmd_opts, key_opts)
  bind_all("dap.ui_toggle_sidebar", function()
    dapui.toggle(1)
  end, cmd_opts, key_opts)
  bind_all("dap.ui_toggle_tray", function()
    dapui.toggle(2)
  end, cmd_opts, key_opts)
  bind_all("dap.continue", function()
    load_launch_json()
    dap.continue()
  end, cmd_opts, key_opts)
  bind_all("dap.terminate", function()
    dap.terminate()
  end, cmd_opts, key_opts)
  bind_all("dap.step_over", function()
    dap.step_over()
  end, cmd_opts, key_opts)
  bind_all("dap.step_into", function()
    dap.step_into()
  end, cmd_opts, key_opts)
  bind_all("dap.step_out", function()
    dap.step_out()
  end, cmd_opts, key_opts)
  bind_all("dap.toggle_breakpoint", function()
    dap.toggle_breakpoint()
  end, cmd_opts, key_opts)
  bind_all("dap.clear_breakpoints", function()
    dap.clear_breakpoints()
  end, cmd_opts, key_opts)
  bind_all("dap.breakpoint_condition", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, cmd_opts, key_opts)
  bind_all("dap.breakpoint_log", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, cmd_opts, key_opts)
  bind_all("dap.repl_toggle", function()
    dap.repl.toggle()
  end, cmd_opts, key_opts)
  bind_all("dap.run_last", function()
    dap.run_last()
  end, cmd_opts, key_opts)
end

return M
