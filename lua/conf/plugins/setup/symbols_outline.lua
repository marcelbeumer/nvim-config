local M = {}

M.setup = function()
  vim.keymap.set("n", "<leader>/", "<cmd>SymbolsOutline<cr>", {})
  vim.g.symbols_outline = {
    highlight_hovered_item = false,
    show_guides = true,
    auto_preview = false,
    position = "left",
    keymaps = {
      close = { "q" },
      hover_symbol = "K",
      toggle_preview = "P",
    },
  }
end

return M
