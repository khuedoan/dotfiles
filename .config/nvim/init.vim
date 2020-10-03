" Options
set cursorline                  " Highlight the current line of the cursor
set expandtab                   " Use spaces when tab is inserted
set incsearch                   " Highlight match while typing search pattern
set mouse=a                     " Enable mouse support
set noshowmode                  " Hide mode infomation on the last line
set number                      " Print the line number
set relativenumber              " Show relative line number
set scrolloff=1                 " Minimum number of lines above and below cursor
set shiftwidth=4                " Number of spaces to use for indent step
set signcolumn=yes              " Always display sign column
set splitbelow                  " New window from split is below the current one
set splitright                  " New window is put right of the current one
set tabstop=4                   " Number of spaces that Tab in file uses
set termguicolors               " Use 24-bit color
set updatetime=100              " Delay before writing to swap file
set showtabline=2               " Always show tab line

" Source other config files
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/keybindings.vim
