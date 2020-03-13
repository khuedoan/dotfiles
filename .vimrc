"+----------+
"| SETTINGS |
"+----------+

" Options
set background=dark            " Use colors that look good on a dark background
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set cursorline                 " Highlight the current line of the cursor
set display=truncate           " Show @@@ in the last line if it is truncated
set expandtab                  " Use spaces when tab is inserted
set hidden                     " Allow loading a buffer in a window that currently has a modified buffer
set history=200                " Keep 200 lines of command line history
set incsearch                  " Highlight match while typing search pattern
set mouse=a                    " Enable mouse in all modes
set nocompatible               " Use Vim settings, rather than Vi settings
set noshowmode                 " Hide mode infomation on the last line
set nrformats-=octal           " Do not recognize octal numbers for Ctrl-A and Ctrl-X
set number                     " Print the line number
set relativenumber             " Show relative line number
set ruler                      " Show the cursor position all the time
set scrolloff=1                " Minimum number of lines above and below cursor
set shiftwidth=4               " Number of spaces to use for indent step
set showcmd                    " Display incomplete commands
set signcolumn=yes             " Always display sign column
set splitbelow                 " New window from split is below the current one
set splitright                 " New window is put right of the current one
set tabstop=4                  " Number of spaces that Tab in file uses
set termguicolors              " Use 24-bit color
set ttimeout                   " Time out for key codes
set ttimeoutlen=100            " Wait up to 100ms after Esc for special key
set wildmenu                   " Display completion matches in a status line
filetype plugin indent on      " Enable file type detection
syntax on                      " Turn on syntax highlighting

" Jumps to the last known position in a file after opening it
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction
augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" Change cursor shape in different modes
let &t_EI = "\033[2 q" " NORMAL  █
let &t_SI = "\033[5 q" " INSERT  |
let &t_SR = "\033[3 q" " REPLACE _

" Split separator
set fillchars+=vert:\│
hi VertSplit cterm=none ctermbg=none

"+-------------+
"| KEY MAPPING |
"+-------------+

" Don't use Ex mode, use Q for formatting.
map Q gq

" Save and quit
cmap sudow w !sudo /usr/bin/tee > /dev/null %
nnoremap <C-S> :w<CR>
nnoremap <C-Q> :q<CR>

" Buffer
nnoremap <C-t> :Files<CR>
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>
nnoremap <LEADER>d :bp<CR>:bd #<CR>

" Copy and paste with system clipboard
vmap <C-c> "+y
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Basic Emacs bindings in Insert mode
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>

"+---------+
"| PLUGINS |
"+---------+

" Auto install plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins list
call plug#begin('~/.vim/plugged')
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'rlue/vim-barbaric'
Plug 'sheerun/vim-polyglot'
call plug#end()

"+----------------+
"| PLUGINS CONFIG |
"+----------------+

" Theme
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
colorscheme dracula

" Sneak
let g:sneak#label = 1

" Conquer of Completion
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GitGutter
autocmd BufWritePost * GitGutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_modified = '▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_modified_removed = '▌'
highlight GitGutterAdd          ctermfg=Green
highlight GitGutterChange       ctermfg=Yellow
highlight GitGutterDelete       ctermfg=Red
highlight GitGutterChangeDelete ctermfg=Blue
