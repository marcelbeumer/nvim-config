local M = {}

M.setup = function()
  local context = require("treesitter-context")
  local bind_all = require("conf.bindings").bind_all
  local key_opts = { noremap = true, silent = true }

  context.setup({
    separator = " ",
  })

  bind_all("treesitter_context.goto", function()
    vim.cmd.normal("m`") -- add current pos to jumplist
    context.go_to_context() -- jump to parent context
  end, {}, key_opts)
end

return M
