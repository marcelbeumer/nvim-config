local M = {}

M.setup = function()
  local dap = require("dap")
  dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
  }
  dap.configurations.javascript = {
    {
      name = "Launch",
      type = "node2",
      request = "launch",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      name = "Attach to process",
      type = "node2",
      request = "attach",
      processId = require("dap.utils").pick_process,
    },
  }

  -- vim.cmd([[
  --   nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
  --   nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
  --   nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
  --   nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
  --   nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
  --   nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  --   nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  --   nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
  --   nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
  -- ]])

  require("dapui").setup()
end

return M
