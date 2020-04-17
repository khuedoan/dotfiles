"+----------+
"| SETTINGS |
"+----------+

" Options
set cursorline     " Highlight the current line of the cursor
set expandtab      " Use spaces when tab is inserted
set noshowmode     " Hide mode infomation on the last line
set number         " Print the line number
set relativenumber " Show relative line number
set scrolloff=1    " Minimum number of lines above and below cursor
set shiftwidth=4   " Number of spaces to use for indent step
set splitbelow     " New window from split is below the current one
set splitright     " New window is put right of the current one
set tabstop=4      " Number of spaces that Tab in file uses
set termguicolors  " Use 24-bit color

" Jumps to the last known position in a file after opening it
autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

"+-------------+
"| KEY MAPPING |
"+-------------+

" Save and quit
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>

" Buffer
nnoremap <C-t> :Files<CR>
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>
nnoremap <LEADER>d :bp<CR>:bd #<CR>

" Copy with system clipboard
vmap <C-c> "+y

" Basic Emacs bindings in Insert mode
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-e> <End>

"+---------+
"| PLUGINS |
"+---------+

" List of plugins
call plug#begin()
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'sheerun/vim-polyglot'
call plug#end()

" Theme
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
colorscheme dracula

" Lightline
let g:lightline = {
    \ 'colorscheme': 'dracula',
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

