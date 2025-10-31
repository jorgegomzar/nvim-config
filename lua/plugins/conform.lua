-- NOTE: to install formatters use Mason
return {
  "stevearc/conform.nvim",
  lazy = false,
  event = "BufWritePre",
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      -- formatting is done by the vim.lsp.format
      python = { "ruff_fix", "ruff_format", "ruff_organize_imports", lsp_format = "first" },
      toml = { "pyproject-fmt" },
      groovy = { "npm-groovy-lint" },
      yaml = { "yamlfmt" },
      css = { "prettier" },
      html = { "prettier" },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return { timeout_ms = 500, lsp_format = "fallback", async = false }
    end,
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! disables for this buffer only
        vim.b.disable_autoformat = true
      else
        -- FormatDisable disables globally
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function(args)
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Enable autoformat-on-save" })
  end,
  keys = {
    {
      "<leader>tf",
      function()
        if vim.b.disable_autoformat then
          vim.cmd "FormatEnable"
          vim.notify "Enabled autoformat for current buffer"
        else
          vim.cmd "FormatDisable!"
          vim.notify "Disabled autoformat for current buffer"
        end
      end,
      desc = "Toggle autoformat for current buffer",
    },
    {
      "<leader>tF",
      function()
        if vim.g.disable_autoformat then
          vim.cmd "FormatEnable"
          vim.notify "Enabled autoformat globally"
        else
          vim.cmd "FormatDisable"
          vim.notify "Disabled autoformat globally"
        end
      end,
      desc = "Toggle autoformat globally",
    },
  },
}
