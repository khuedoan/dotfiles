" Source the global vim configuration file
:if filereadable("/usr/share/vim/vim81/defaults.vim")
:   source /usr/share/vim/vim81/defaults.vim
:endif

" Automatically install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
call plug#end()

" Airline
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled = 1

" NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Options
set number          " Print the line number in front of each line
set relativenumber  " Show relative line number in front of each line 
set incsearch       " Highlight match while typing search pattern
set splitbelow      " New window from split is below the current one
set splitright      " New window is put right of the current one
set scrolloff=1     " Minimum number of lines above and below cursor
set tabstop=4       " Number of spaces that <Tab> in file uses
set shiftwidth=4    " Number of spaces to use for (auto)indent step
set expandtab       " Use spaces when <Tab> is inserted
set cursorline      " Highlight the screen line of the cursor

" Cursor line
hi CursorLine cterm=none ctermbg=DarkGray

" Change cursor shape in different modes
" 0    Blink Block
" 1    Blink Block
" 2    Steady Block
" 3    Blink Underline
" 4    Steady Underline
" 5    Blink Bar
" 6    Steady Bar
let &t_EI = "\<Esc>[2 q" " NORMAL
let &t_SI = "\<Esc>[5 q" " INSERT
let &t_SR = "\<Esc>[3 q" " REPLACE
