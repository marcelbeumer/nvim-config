local M = {}

M.setup = function()
  require("neotest").setup({
    adapters = {
      require("neotest-jest")({
        jestCommand = "jest",
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
      }),
    },
  })

  vim.keymap.set("n", "<leader>xt", function() end, { desc = "Test..." })

  vim.keymap.set("n", "<leader>xts", function()
    require("neotest").summary.toggle()
  end, { desc = "Toggle test summary" })

  vim.keymap.set("n", "<leader>xto", function()
    require("neotest").output.open({ enter = true })
  end, { desc = "Open test output" })

  vim.keymap.set("n", "<leader>xtr", function()
    require("neotest").run.run()
  end, { desc = "Run the nearest test" })

  vim.keymap.set("n", "<leader>xtl", function()
    require("neotest").run.run_last()
  end, { desc = "Run last test" })

  vim.keymap.set("n", "<leader>xtR", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end, { desc = "Run the current file" })

  vim.keymap.set("n", "<leader>xtd", function()
    require("neotest").run.run({ strategy = "dap" })
  end, { desc = "Debug the nearest test" })

  vim.keymap.set("n", "<leader>xtx", function()
    require("neotest").run.stop()
  end, { desc = "Stop the nearest test" })

  vim.keymap.set("n", "<leader>xta", function()
    require("neotest").run.attach()
  end, { desc = "Attach to the nearest test" })
end

return M
