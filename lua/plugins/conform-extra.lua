vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.g.autoformat = false
    vim.notify("Disabled autoformat globally")
  else
    vim.b.autoformat = false
    vim.notify("Disabled autoformat locally")
  end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function(args)
  vim.notify("Enabled autoformat")
  vim.b.autoformat = true
  vim.g.autoformat = true
end, { desc = "Enable autoformat-on-save" })

return {
  "stevearc/conform.nvim",
  lazy = false,
  event = "BufWritePre",
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}
    opts.notify_on_error = false

    opts.formatters_by_ft.python = { "ruff_fix", "ruff_format", "ruff_organize_imports", lsp_format = "first" }

    opts.formatters.ruff_format = {
      command = "ruff",
      args = {
        "format",
        "--line-length",
        "120",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
    }

    return opts
  end,
  keys = {
    {
      "<leader>tf",
      function()
        if vim.b.autoformat then
          vim.cmd("FormatDisable")
        else
          vim.cmd("FormatEnable")
        end
      end,
      desc = "Toggle autoformat for current buffer",
    },
    {
      "<leader>tF",
      function()
        if vim.g.autoformat then
          vim.cmd("FormatDisable!")
        else
          vim.cmd("FormatEnable")
        end
      end,
      desc = "Toggle autoformat globally",
    },
  },
}
