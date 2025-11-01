return {
  "pogyomo/submode.nvim",
  lazy = false,
  config = function()
    local submode = require("submode")

    submode.create("WindowResize", {
      mode = "n",
      enter = "<C-w>r",
      leave = { "q", "<ESC>" },
      default = function(register)
        register("<", "<C-w><")
        register(">", "<C-w>>")
        register("+", "<C-w>+")
        register("-", "<C-w>-")
      end,
    })
  end,
}
