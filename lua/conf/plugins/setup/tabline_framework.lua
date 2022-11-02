local M = {}

M.handleHarpoonClick = function(idx)
  require("harpoon.ui").nav_file(idx)
end

M.setup = function()
  vim.o.showtabline = 2

  require("tabline_framework").setup({
    render = function(f)
      local hi = require("tabline_framework.highlights")

      local marks = require("harpoon.mark")
      local len = marks.get_length()
      local curr = marks.get_current_index()

      for idx = 1, len do
        local current = curr == idx
        if current then
          f.set_colors(hi.tabline_sel())
        else
          f.set_colors(hi.tabline())
        end

        local fname = marks.get_marked_file_name(idx)
        local short_name = vim.fn.fnamemodify(fname, ":t")
        local exists = vim.fn.bufexists(fname) ~= 0
        if exists then
          local bufnr = vim.fn.bufnr(fname)
          if vim.api.nvim_buf_get_option(bufnr, "modified") then
            f.add("[+]")
          end
        end

        f.add("%" .. idx .. "@v:lua.require'conf.plugins.setup.tabline_framework'.handleHarpoonClick@")
        f.add(" ")
        f.add(short_name)
        f.add(" ")
        f.add("%X")
      end

      f.set_colors(hi.tabline())
      f.add_spacer(" ")

      f.make_tabs(function(info)
        f.add(" " .. info.index .. " ")
      end)

      f.set_colors(hi.tabline())
    end,
  })
end

return M
