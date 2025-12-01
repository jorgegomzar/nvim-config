return {
  -- Install the themes you want
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },

  -- Configure LazyVim to load one by default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "carbonfox", -- or "carbonfox", "kanagawa"
    },
  },
}
