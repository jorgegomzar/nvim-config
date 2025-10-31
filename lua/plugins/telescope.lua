local opts = require "nvchad.configs.telescope"

opts.file_ignore_patterns = {
  "venv",
  "node_modules",
}

return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {},
  opts = opts,
  config = function(_opts)
    require("telescope").setup(_opts)

    -- require("telescope").load_extension("noice")
    -- require("telescope").load_extension("ntfy")
  end,
}
