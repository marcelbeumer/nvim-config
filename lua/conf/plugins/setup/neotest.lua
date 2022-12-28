local M = {}

M.setup = function()
  local neotest = require("neotest")
  local bindings = require("conf.bindings")
  local bind_all = bindings.bind_all
  local key_opts = { noremap = true, silent = true }
  local cmd_opts = {}

  neotest.setup({
    adapters = {
      require("neotest-go"),
      require("neotest-jest")({
        jestCommand = "jest",
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
      }),
    },
  })

  bind_all("neotest.output", neotest.output.open, cmd_opts, key_opts)
  bind_all("neotest.summary", neotest.summary.toggle, cmd_opts, key_opts)
  bind_all("neotest.output_panel", neotest.output_panel.toggle, cmd_opts, key_opts)
  bind_all("neotest.run_nearest", neotest.run.run, cmd_opts, key_opts)
  bind_all("neotest.run_last", neotest.run.run_last, cmd_opts, key_opts)
  bind_all("neotest.run_file", function()
    neotest.run.run(vim.fn.expand("%"))
  end, cmd_opts, key_opts)
  bind_all("neotest.debug_nearest", function()
    require("neotest").run.run({ strategy = "dap" })
  end, cmd_opts, key_opts)
  bind_all("neotest.stop_nearest", function()
    require("neotest").run.stop()
  end, cmd_opts, key_opts)
  bind_all("neotest.attach_nearest", function()
    require("neotest").run.attach()
  end, cmd_opts, key_opts)
end

return M
