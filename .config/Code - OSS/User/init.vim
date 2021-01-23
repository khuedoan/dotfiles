" Leader key
nmap <SPACE> <NOP>
let mapleader = " "

" Comment
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Auto install plugin manager
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" List of plugins
call plug#begin()
Plug 'romainl/vim-cool'
Plug 'unblevable/quick-scope'
call plug#end()

" Quick scope
highlight QuickScopePrimary gui=bold,underline cterm=underline
highlight QuickScopeSecondary gui=underline cterm=underline
