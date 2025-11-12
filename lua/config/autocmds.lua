-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command
local bufusercmd = vim.api.nvim_buf_create_user_command

local map = LazyVim.safe_keymap_set

autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("bufdelpost_autocmd", {}),
  desc = "BufDeletePost User autocmd",
  callback = function()
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "BufDeletePost",
      })
    end)
  end,
})

autocmd("User", {
  pattern = "BufDeletePost",
  group = vim.api.nvim_create_augroup("dashboard_delete_buffers", {}),
  desc = "Open Dashboard when no available buffers",
  callback = function(ev)
    local deleted_name = vim.api.nvim_buf_get_name(ev.buf)
    local deleted_ft = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
    local deleted_bt = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })
    local dashboard_on_empty = deleted_name == "" and deleted_ft == "" and deleted_bt == ""

    if dashboard_on_empty then
      Snacks.dashboard.open()
    end
  end,
})

-- mongosh
usercmd("Mongosh", function()
  if not vim.g.mongo_uri then
    vim.g.mongo_uri =
      vim.fn.system("direnv exec ~/dotfiles/.envrc/reportal/mongo printenv MONGO_URI"):match("^[^\n]*\n([^\n]*)")

    if vim.v.shell_error ~= 0 or vim.g.mongo_uri == "" then
      vim.notify("Failed to retrieve MongoDB URI from 1Password", vim.log.levels.ERROR)
      return
    end
  end

  local cmd = "mongosh '" .. vim.g.mongo_uri .. "'"
  Snacks.terminal.toggle(cmd)
end, {})
map("n", "<leader>fm", function()
  vim.cmd("Mongosh")
end, { desc = "Toggle mongosh console" })

-- PYTHON
augroup("Python", { clear = true })

autocmd("FileType", {
  pattern = "python",
  group = "Python",
  desc = "Python specific commands",
  callback = function(ev)
    -- Convert unittest asserts to pytest's
    bufusercmd(ev.buf, "UnittestToPytest", function()
      local ok, _ = pcall(function()
        local t = {
          ":%s/self\\.assertEqual(\\(.*\\), \\(.*\\))$/assert \\1 == \\2/g",
          ":%s/self\\.assertNotEqual(\\(.*\\), \\(.*\\))$/assert \\1 != \\2/g",
          ":%s/self\\.assertTrue(\\(.*\\))$/assert \\1 is True/g",
          ":%s/self\\.assertFalse(\\(.*\\))$/assert \\1 is False/g",
          ":%s/self\\.assertIs(\\(.*\\), \\(.*\\))$/assert \\1 is \\2/g",
          ":%s/self\\.assertIsNot(\\(.*\\), \\(.*\\))$/assert \\1 is not \\2/g",
          ":%s/self\\.assertIsNone(\\(.*\\))$/assert \\1 is None/g",
          ":%s/self\\.assertIsNotNone(\\(.*\\))$/assert \\1 is not None/g",
          ":%s/self\\.assertIn(\\(.*\\), \\(.*\\))$/assert \\1 in \\2/g",
          ":%s/self\\.assertNotIn(\\(.*\\), \\(.*\\))$/assert \\1 not in \\2/g",
          ":%s/self\\.assertIsInstance(\\(.*\\), \\(.*\\))$/assert isinstance(\\1,\\2)/g",
          ":%s/self\\.assertNotIsInstance(\\(.*\\), \\(.*\\))$/assert not isinstance(\\1,\\2)/g",
        }
        for _, subs_pattern in ipairs(t) do
          vim.cmd(subs_pattern)
        end
      end)
      if not ok then
        vim.notify("Error replacing unittest asserts", vim.log.levels.ERROR)
      end
    end, {})

    -- Run current file
    bufusercmd(ev.buf, "PyRun", function()
      local cmd = "uv run --no-project " .. vim.fn.expand("%:p")
      local term =
        Snacks.terminal.toggle(cmd .. " ; " .. vim.o.shell, { win = { style = "split" }, auto_close = false })
      term:show()
    end, {})

    -- PyTest
    bufusercmd(ev.buf, "PyTest", function(opts)
      local file_path
      local cmd_ruff, cmd_pytest, cmd

      if opts.bang then
        -- :PyTest! → test all files
        file_path = vim.fn.getcwd()
      else
        -- :PyTest → test only current file
        file_path = vim.fn.expand("%:p")
      end

      cmd_ruff = "ruff check " .. file_path
      cmd_pytest = "pytest -s " .. file_path

      cmd = cmd_ruff .. " && " .. cmd_pytest

      if vim.fn.input("Use mypy? [Y/n] ") ~= "n" then
        cmd = cmd_ruff
          .. " && mypy --python-executable "
          .. require("venv-selector").python()
          .. " "
          .. file_path
          .. " && "
          .. cmd_pytest
      end

      -- to ensure we re-use the same terminal we toggle it and then call show
      local term = Snacks.terminal.toggle(
        "set -x ; " .. cmd .. " ; " .. vim.o.shell,
        { win = { style = "split" }, auto_close = false }
      )
      term:show()
    end, {
      bang = true, -- allow "!" in the command
      desc = "Run pytest (with ! to run all tests)",
    })

    map("n", "<leader>pyr", function()
      vim.cmd("PyRun")
    end, { buffer = ev.buf, desc = "Python run file" })
    map("n", "<leader>pytt", function()
      vim.cmd("PyTest")
    end, { buffer = ev.buf, desc = "Python test and linters for file" })
    map("n", "<leader>pyta", function()
      vim.cmd("PyTest!")
    end, { desc = "Python test and linters for all" })

    vim.notify("Registered python commands")
  end,
})
