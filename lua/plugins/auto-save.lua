return {
  "okuuva/auto-save.nvim",
  event = "VimEnter",
  opts = {
    condition = function(buf)
      local fn = vim.fn
      local buf_filename = fn.expand("%")
      local utils = require("auto-save.utils.data")

      -- do not save query buffers
      if string.find(buf_filename, "query") then
        return false
      end

      -- dadbod names differently to table list queries
      if string.find(buf_filename, "List") then
        return false
      end

      -- don't save for `sql` file types
      if utils.not_in(fn.getbufvar(buf, "&filetype"), { 'sql' }) then
        return true
      end

      return false
    end
  },
}
