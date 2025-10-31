require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- tmux
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Window left" })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Window right" })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Window down" })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Window up" })

-- noice
map("n", "<leader>nd", "<cmd> NoiceDismiss<CR>", { desc = "Noice dismiss" })
map("n", "<leader>t,", "<cmd> Telescope notify<CR>", { desc = "Telescope notify" })
map("n", "<leader>t.", "<cmd> Telescope ntfy<CR>", { desc = "Telescope ntfy" })

-- auto-save
map("n", "<leader>tas", "<cmd> ASToggle<CR>", { desc = "Toggle auto save" })

--tabs
map("n", "<leader>tc", "<cmd> tabnew<CR>", { desc = "Tab create" })
map("n", "<leader>tn", "<cmd> tabNext<CR>", { desc = "Tab next" })
map("n", "<leader>tx", "<cmd> tabclose<CR>", { desc = "Tab close" })

-- buffers
map("n", "<leader>cob", ":%bd|e#|bd#<CR>", { desc = "Buffers Close others" })

-- go to link
map(
  "n",
  "gx",
  "<cmd> silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>",
  { desc = "Open file or URL under cursor" }
)

--git
map("n", "<leader>gb", ":G blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", ":Gvdiff<CR>", { desc = "Git diff vert" })

-- python
map("n", "<leader>pyr", ":PythonRun<CR>", { desc = "Python Run current file" })
map("n", "<leader>pyta", ":PythonTestAll<CR>", { desc = "Python linters + tests for all files" })
map("n", "<leader>pytt", ":PythonTestThis<CR>", { desc = "Python linters + tests for current buffer" })
map("n", "<leader>pyf", ":PythonFormatThis<CR>", { desc = "Python format current buffer" })
