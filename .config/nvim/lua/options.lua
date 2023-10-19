vim.opt.ignorecase = true     -- ignore case in search patterns
vim.opt.smartcase = true      -- smart case
vim.opt.smartindent = true    -- make indenting smarter again
vim.opt.splitbelow = true     -- force all horizontal splits to go below current window
vim.opt.splitright = true     -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false      -- creates a swapfile
vim.opt.undofile = true       -- enable persistent undo
vim.opt.expandtab = true      -- convert tabs to spaces
vim.opt.shiftwidth = 4        -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4           -- insert 2 spaces for a tab
vim.opt.cursorline = true     -- highlight the current line
vim.opt.number = true         -- set numbered lines
vim.opt.relativenumber = true -- show relative line number
vim.opt.signcolumn = "yes"    -- always show the sign column, otherwise it would shift the text each time
vim.opt.scrolloff = 3         -- minimal number of screen lines to keep above and below the cursor

-- Custom statusline
vim.opt.laststatus = 3        -- global statusline
vim.opt.statusline =
    "%#Substitute# %Y %0*" .. -- filetype
    " %f " ..                 -- path to file
    "%m" ..                   -- modifed
    "%r" ..                   -- readonly
    "%=" ..                   -- separator
    " %{&fileencoding} " ..   -- file encoding
    "|" ..                    -- padding
    " %{&fileformat} " ..     -- file format
    "|" ..                    -- padding
    " %c:%l/%L "              -- column at line per total lines
