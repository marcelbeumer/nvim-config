local M = {}

M.setup = function()
  require("project_nvim").setup({ manual_mode = true, show_hidden = true })
  require("telescope").load_extension("projects")
  vim.keymap.set("n", "<leader>fp", ":Telescope projects<cr>", { silent = true, desc = "Switch project" })
end

return M
