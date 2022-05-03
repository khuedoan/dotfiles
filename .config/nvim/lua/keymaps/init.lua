-- Leader

vim.g.mapleader = ' '

-- Copy and paste with system clipboard

vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('i', '<C-v>', '<C-r>+')

-- Save and quit

vim.keymap.set('n', '<C-s>', ':write<CR>')
vim.keymap.set('n', '<C-q>', ':quit<CR>')

-- Replace

vim.keymap.set('n', '<LEADER>r', ':%s///g<LEFT><LEFT>')
