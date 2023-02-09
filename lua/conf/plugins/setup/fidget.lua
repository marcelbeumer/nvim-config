local M = {}

M.setup = function()
  require("fidget").setup({
    timer = {
      fidget_decay = 500, -- how long to keep around empty fidget, in ms
      task_decay = 500, -- how long to keep around completed task, in ms
    },
  })
end

return M
