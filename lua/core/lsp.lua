-- lsp configuration
-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()
require("mason").setup()

vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.lsp.enable {
  -- lua
  "lua_ls",
  -- godot
  "gdscript",
  -- tilt
  "tilt_ls",
  -- python
  "pyright",
  "ruff",
  -- "ty", -- still in alpha
}

-- diagnostics
vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
}
