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
  return {
    go = {
      {
        type = "go",
        name = "Debug (file)",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test (file)", -- configuration for debugging test files
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
    },
  }
end

return M
