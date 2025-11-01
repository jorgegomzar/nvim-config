return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = {
      auto_refresh = true,
      stay_on_this_version = true,
      name = { ".venv", "venv", "env" },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Restore cached Python venv" },
    },
    config = function(_, opts)
      local venv_selector = require("venv-selector")
      venv_selector.setup(opts)

      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          -- Try to restore from cache (previously selected venv)
          local ok, _ = pcall(venv_selector.retrieve_from_cache)
          if not ok then
            -- Optionally auto-detect a .venv in the new cwd
            local cwd = vim.fn.getcwd()
            local venv_paths = { cwd .. "/.venv", cwd .. "/venv", cwd .. "/env" }
            for _, path in ipairs(venv_paths) do
              if vim.fn.isdirectory(path) == 1 then
                venv_selector.activate_from_path(path)
                vim.notify("Activated venv: " .. path, vim.log.levels.INFO)
                break
              end
            end
          end
        end,
      })
    end,
  },
}
