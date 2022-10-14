vim.g.tmux_navigator_no_mappings = 1

vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<cr>", { silent = true })
vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<cr>", { silent = true })
vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<cr>", { silent = true })
vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<cr>", { silent = true })
