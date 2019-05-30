"""""""""""
" Options "
"""""""""""

" Source the default vimrc file
:if filereadable("/usr/share/vim/vim81/defaults.vim")
:   source /usr/share/vim/vim81/defaults.vim
:endif

" Options
set confirm                  " Ask what to do about unsaved/read-only files
set number                   " Print the line number
set relativenumber           " Show relative line number
set incsearch                " Highlight match while typing search pattern
set splitbelow               " New window from split is below the current one
set splitright               " New window is put right of the current one
set scrolloff=1              " Minimum number of lines above and below cursor
set tabstop=4                " Number of spaces that Tab in file uses
set shiftwidth=4             " Number of spaces to use for indent step
set expandtab                " Use spaces when Tab is inserted
set cursorline               " Highlight the screen line of the cursor
set clipboard=autoselectplus " Auto select desktop clipboard

" Cursor line
hi CursorLine cterm=none ctermbg=060

" Change cursor shape in different modes
let &t_EI = "\033[2 q" " NORMAL  █
let &t_SI = "\033[5 q" " INSERT  |
let &t_SR = "\033[3 q" " REPLACE _

"""""""""""
" Key map "
"""""""""""

" Save as root
cmap W w !sudo /usr/bin/tee > /dev/null %

"""""""""""
" Plugins "
"""""""""""

" Automatically install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins list
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'justinmk/vim-sneak'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
call plug#end()

""""""""""""""""""
" Plugins config "
""""""""""""""""""

" Airline
let g:airline_theme = 'dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Markdown Preview
let g:mkdp_auto_start = 1
let g:mkdp_browser = 'surf'
