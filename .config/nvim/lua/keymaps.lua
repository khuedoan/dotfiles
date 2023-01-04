-- --Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Save and quit
vim.keymap.set("n", "<C-s>", ":update<cr>", { silent = true })
vim.keymap.set("n", "<C-q>", ":quit<cr>", { silent = true })

-- Copy to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
