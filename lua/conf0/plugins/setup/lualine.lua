local M = {}

M.setup = function()
  local filename = { "filename", path = 1 }
  local diff = { "diff", colored = false }
  local diagnostics = { "diagnostics", colored = false }
  local aerial = { "aerial", colored = false, depth = 1 }

  require("lualine").setup({
    options = { section_separators = "", component_separators = "" },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename, diff, diagnostics, aerial },
      lualine_x = { "searchcount", "progress", "location" },
      lualine_y = {},
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = { "progress", "location" },
      lualine_y = {},
      lualine_z = {},
    },
  })
end

return M
