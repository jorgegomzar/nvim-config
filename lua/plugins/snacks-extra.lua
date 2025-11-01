local cover = "chafa --format symbols --symbols vhalf --size 39x25 --stretch ~/.config/nvim/media/chainsaw.jpg"

-- lazy.nvim
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        {
          section = "terminal",
          cmd = cover,
          height = 39,
          padding = 1,
        },
        { section = "header", pane = 2 },
        {
          pane = 2,
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
