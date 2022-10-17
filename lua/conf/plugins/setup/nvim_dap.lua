local M = {}

M.setup = function()
  require("dap-vscode-js").setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
    -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
  })

  for _, language in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/jest/bin/jest.js",
          "--runInBand",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
    }
  end

  local function map(mode, l, r, desc)
    local opts = {}
    opts.desc = desc
    vim.keymap.set(mode, l, r, opts)
  end

  require("nvim-dap-virtual-text").setup({})
  map({ "n" }, "<leader>xd", function() end, "Debug...")
  map({ "n" }, "<leader>xdb", ":lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint")
  map({ "n" }, "<leader>xdr", ":lua require('dap').continue()<cr>", "Continue/run")
  map({ "n" }, "<leader>xdt", ":lua require('dapui').toggle()<cr>", "UI toggle")

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
