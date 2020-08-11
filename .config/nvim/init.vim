"+----------+
"| SETTINGS |
"+----------+

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
set switchbuf=usetab            " Behavior when switching between buffers

" Jumps to the last known position in a file after opening it
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |     exe "normal! g`\""
    \ | endif

"+-------------+
"| KEY MAPPING |
"+-------------+

" Leader key
noremap <SPACE> <NOP>
let mapleader = " "

" Save and quit
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>

" Buffer
nnoremap <TAB> :sbnext<CR>
nnoremap <S-TAB> :sbprevious<CR>
nnoremap <LEADER>d :bp<CR>:bd #<CR>

" Copy with system clipboard
vmap <C-c> "+y

" Clear last search highlighting
nnoremap <C-c> :noh<CR>

"+---------+
"| PLUGINS |
"+---------+

" Auto install plugin manager
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" List of plugins
call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'mattn/vim-gist'
Plug 'mattn/webapi-vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mzlogin/vim-markdown-toc'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'preservim/nerdtree'
Plug 'rlue/vim-barbaric'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
call plug#end()

" Auto install missing plugin
autocmd VimEnter *
    \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \ |     PlugInstall --sync | q
    \ | endif

" Theme
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
colorscheme dracula

" Tmux navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-`> :TmuxNavigatePrevious<cr>

" Lightline
let g:lightline = {
    \ 'colorscheme': 'dracula',
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ 'tabline': { 'left': [ [ 'buffers'] ], 'right': [ [ 'tabs' ] ] },
    \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
    \ 'component_type': { 'buffers': 'tabsel' },
    \ 'component_raw': { 'buffers': 1 }
    \ }
let g:lightline#bufferline#clickable = 1

" fzf
nnoremap <C-t> :Files<CR>
nnoremap <LEADER>b :Buffers<CR>

" Sneak
let g:sneak#label = 1
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F

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

let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-pyright',
    \ 'coc-tsserver',
    \ 'coc-yaml',
    \ ]

" NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Barbaric
let g:barbaric_default = 'xkb:us::eng'
