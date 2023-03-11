local M = {}

M.setup = function()
  local neotest = require("neotest")
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  -- from https://github.com/nvim-neotest/neotest-go
  -- get neotest namespace (api call creates or returns namespace)
  local neotest_ns = vim.api.nvim_create_namespace("neotest")
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
        return message
      end,
    },
  }, neotest_ns)

  neotest.setup({
    quickfix = {
      open = false,
    },
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

  bind_all("neotest.output", neotest.output.open, {}, key_opts)
  bind_all("neotest.summary", neotest.summary.toggle, {}, key_opts)
  bind_all("neotest.output_panel", neotest.output_panel.toggle, {}, key_opts)
  bind_all("neotest.run_nearest", neotest.run.run, {}, key_opts)
  bind_all("neotest.run_last", neotest.run.run_last, {}, key_opts)
  bind_all("neotest.run_file", function()
    neotest.run.run(vim.fn.expand("%"))
  end, {}, key_opts)
  bind_all("neotest.debug_nearest", function()
    require("neotest").run.run({ strategy = "dap" })
  end, {}, key_opts)
  bind_all("neotest.stop_nearest", function()
    require("neotest").run.stop()
  end, {}, key_opts)
  bind_all("neotest.attach_nearest", function()
    require("neotest").run.attach()
  end, {}, key_opts)
end

return M
