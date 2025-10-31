return {
  "pandalec/jiratui.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "akinsho/toggleterm.nvim",
  },
  opts = {
    filters = {
      default_jql_id = 20,
    },
  },
  config = function(opts)
    require("jiratui").setup(opts)
  end,
}
