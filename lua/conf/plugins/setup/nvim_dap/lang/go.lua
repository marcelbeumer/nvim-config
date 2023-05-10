local M = {}

M.setup = function()
  local dap = require("dap")
  dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }
end

M.configurations = function()
  local nvim_dap = require("conf.plugins.setup.nvim_dap")
  return {
    go = {
      {
        type = "go",
        name = "Debug (file)",
        request = "launch",
        program = "${file}",
      },
      -- configuration for debugging test files
      {
        type = "go",
        name = "Debug test (file)",
        request = "launch",
        mode = "test",
        program = "${file}",
      },
      -- works with go.mod packages and sub packages
      {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
      },
      {
        type = "go",
        name = "Debug test w/ args (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
        args = nvim_dap.prompt_array_fn("dlv args:", "-test.run=TestXXX"),
      },
    },
  }
end

return M
