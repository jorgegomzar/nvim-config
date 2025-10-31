local utils = require "utils"
-- Autocommands

local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_augroup("custom_buffer", { clear = true })

-- highlight yanks
autocmd("TextYankPost", {
  group = "custom_buffer",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { timeout = 500 }
  end,
})

-- show dashboard when no other buffer is open
autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

-- restore cursor position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

----
-- CUSTOM COMMANDS
-- Convert unittest asserts to pytest's
vim.api.nvim_create_user_command("UnittestToPytest", function()
  local ok, result
  ok, result = pcall(vim.cmd, ":%s/self\\.assertEqual(\\(.*\\), \\(.*\\))$/assert \\1 == \\2/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertNotEqual(\\(.*\\), \\(.*\\))$/assert \\1 != \\2/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertTrue(\\(.*\\))$/assert \\1 is True/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertFalse(\\(.*\\))$/assert \\1 is False/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertIs(\\(.*\\), \\(.*\\))$/assert \\1 is \\2/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertIsNot(\\(.*\\), \\(.*\\))$/assert \\1 is not \\2/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertIsNone(\\(.*\\))$/assert \\1 is None/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertIsNotNone(\\(.*\\))$/assert \\1 is not None/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertIn(\\(.*\\), \\(.*\\))$/assert \\1 in \\2/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertNotIn(\\(.*\\), \\(.*\\))$/assert \\1 not in \\2/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertIsInstance(\\(.*\\), \\(.*\\))$/assert isinstance(\\1,\\2)/g")
  ok, result = pcall(vim.cmd, ":%s/self\\.assertNotIsInstance(\\(.*\\), \\(.*\\))$/assert not isinstance(\\1,\\2)/g")
end, {})

-- decode Reportal URLs
vim.api.nvim_create_user_command("ReportalDecodeURLs", function()
  pcall(vim.cmd, ":%s/https:\\/\\/.*\\.bmat\\.com\\/[a-z]*\\/view\\/\\(.*\\)/\\1/")
  pcall(vim.cmd, ":%s/%3D/=/g")
  pcall(vim.cmd, ":%!base64 --decode")
  pcall(vim.cmd, ":%s/\\(\\(\\d\\|[a-z]\\)\\([A-Z]\\)\\)/\\2\\r\\3/g")
end, {})

-- PYTHON
-- Python: run current buffer
vim.api.nvim_create_user_command("PythonRun", function()
  require("nvchad.term").runner {
    pos = "vsp",
    id = "pyr",
    size = 0.5,
    cmd = "uv run --no-project " .. vim.fn.expand "%:p",
    clear_cmd = false,
  }
end, {})

-- Python: test all files
vim.api.nvim_create_user_command("PythonTestAll", function()
  local cmd = "ruff check . && pytest . -s"
  if vim.fn.input "Use mypy? [Y/n] " ~= "n" then
    cmd = "mypy --python-executable " .. utils.get_venv_python() .. " . && " .. cmd
  end

  require("nvchad.term").runner {
    pos = "vsp",
    id = "pyta",
    size = 0.5,
    cmd = cmd,
    clear_cmd = false,
  }
end, {})

-- Python: test current buffer
vim.api.nvim_create_user_command("PythonTestThis", function()
  local file_path = vim.fn.expand "%:p"
  local cmd = "ruff check " .. file_path .. " && pytest -s " .. file_path

  if vim.fn.input "Use mypy? [Y/n] " ~= "n" then
    cmd = "mypy --python-executable " .. utils.get_venv_python() .. " " .. file_path .. " && " .. cmd
  end
  require("nvchad.term").runner {
    pos = "vsp",
    id = "pytt",
    size = 0.5,
    cmd = cmd,
    clear_cmd = false,
  }
end, {})
