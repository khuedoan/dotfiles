-- Leader

vim.g.mapleader = ' '

-- Copy and paste with system clipboard

vim.api.nvim_set_keymap('v', '<C-c>', '"+y',    {noremap = true})
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', {noremap = true})

-- Save and quit

vim.api.nvim_set_keymap('n', '<C-s>', ':write<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-q>', ':quit<CR>',  {noremap = true})

-- Replace

vim.api.nvim_set_keymap('n', '<LEADER>r', ':%s///g<LEFT><LEFT>',  {noremap = true})
