" Source the global vim configuration file
source /usr/share/vim/vim81/defaults.vim

" Options
set number          " Print the line number in front of each line
set relativenumber  " Show relative line number in front of each line 
set incsearch       " Highlight match while typing search pattern
set splitbelow      " New window from split is below the current one
set splitright      " New window is put right of the current one
set scrolloff=1     " Minimum number of lines above and below cursor
set tabstop=4       " Number of spaces that <Tab> in file uses
set softtabstop=4   " Number of spaces that <Tab> uses while editing
set shiftwidth=4    " Number of spaces to use for (auto)indent step

" Change cursor shape in different modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
