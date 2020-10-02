" Leader key
noremap <SPACE> <NOP>
let mapleader = " "

" Save and quit
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>

" Buffer
nnoremap <LEADER>d :bp<CR>:bd #<CR>

" Copy and paste with system clipboard
vnoremap <C-c> "+y
inoremap <C-v> <C-r>+

" Replace last search
nnoremap <LEADER>r :%s///g<LEFT><LEFT>

" Clear last search highlighting
nnoremap <C-c> :noh<CR>
