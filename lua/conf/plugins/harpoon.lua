return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local parse_bookmark = function(value)
        local filepath, row, col, postfix = string.match(value or "", "(.-):(%d+):(%d+)(.*)")

        if not filepath then
          -- We received a postfix or no value at all.
          -- Take information from current window.
          local pos = vim.api.nvim_win_get_cursor(0)
          filepath = require("conf.fs").file_path()
          row = pos[1]
          col = pos[2]
          postfix = value or ""
        end

        return {
          value = filepath .. ":" .. row .. ":" .. col .. postfix,
          filepath = filepath,
          row = tonumber(row),
          col = tonumber(col),
        }
      end

      return {
        bookmarks = {
          create_list_item = function(_, name)
            return { value = parse_bookmark(name).value }
          end,

          select = function(list_item, _, _)
            local bookmark = parse_bookmark(list_item.value)
            vim.cmd.edit(bookmark.filepath)
            vim.api.nvim_win_set_cursor(0, { bookmark.row, bookmark.col })
          end,
        },
      }
    end,

    keys = {
      {
        "<leader>a",
        function()
          local postfix = vim.fn.input("Note: ")
          if postfix ~= "" then
            postfix = " -- " .. postfix
          end
          local harpoon = require("harpoon")
          local bookmarks = harpoon:list("bookmarks")
          local item = bookmarks.config.create_list_item(bookmarks.config, postfix)
          bookmarks:prepend(item)
        end,
        desc = "Add bookmark",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list("bookmarks"), { title = "Bookmarks" })
        end,
        desc = "Show bookmarks",
      },
    },
  },
}
