-------------
-- Aliases --
-------------

local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local map = vim.api.nvim_set_keymap
local o = vim.o
local wo = vim.wo

-------------
-- Options --
-------------

-- Global

o.completeopt = 'menuone,noinsert,noselect'
o.inccommand = 'nosplit'
o.mouse = 'a'
o.scrolloff = 1
o.showmode = false
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.updatetime = 100

-- Buffer

bo.expandtab = true
bo.shiftwidth = 4
bo.tabstop = 4
bo.undofile = true

-- Window

wo.cursorline = true
wo.number = true
wo.relativenumber = true
wo.signcolumn = 'yes'

--------------
-- Mappings --
--------------

-- Leader

g.mapleader = ' '

-- Copy and paste with system clipboard

map('v', '<C-c>', '"+y',    {noremap = true})
map('i', '<C-v>', '<C-r>+', {noremap = true})

-- Save and quit

map('n', '<C-s>', ':write<CR>', {noremap = true})
map('n', '<C-q>', ':quit<CR>',  {noremap = true})

-- Replace

map('n', '<LEADER>r', ':%s///g<LEFT><LEFT>',  {noremap = true})

-------------
-- Plugins --
-------------

-- Auto install plugin manager

local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
end

cmd 'packadd paq-nvim'
local plug = require('paq-nvim').paq

-- Let the plugin manager manage itself

plug {'savq/paq-nvim', opt=true}

-- Plugin list

plug {'APZelos/blamer.nvim'}
plug {'airblade/vim-gitgutter'}
plug {'bronson/vim-visual-star-search'}
plug {'christoomey/vim-tmux-navigator'}
plug {'farmergreg/vim-lastplace'}
plug {'hoob3rt/lualine.nvim'}
plug {'iamcco/markdown-preview.nvim', run=vim.fn['mkdp#util#install']}
plug {'jiangmiao/auto-pairs'}
plug {'joshdick/onedark.vim'}
plug {'junegunn/fzf'}
plug {'junegunn/fzf.vim'}
plug {'justinmk/vim-sneak'}
plug {'lukas-reineke/indent-blankline.nvim', branch='lua'} -- TODO use master branch when 0.5 is out
plug {'mcchrish/nnn.vim'}
plug {'neovim/nvim-lspconfig'}
plug {'norcalli/nvim-colorizer.lua'}
plug {'nvim-lua/completion-nvim'}
plug {'romainl/vim-cool'}
plug {'romgrk/barbar.nvim'}
plug {'sheerun/vim-polyglot'}
plug {'tpope/vim-commentary'}
plug {'tpope/vim-surround'}

-- Auto install and clean plugins

require('paq-nvim').install()
require('paq-nvim').clean()

-------------------
-- Plugin config --
-------------------

-- Theme

cmd 'autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE'
cmd 'colorscheme onedark'

-- Buffer line

g.bufferline = {
  animation = false,
  icons = false,
  maximum_padding = 0
}

map('n', '<LEADER><TAB>', ':BufferPick<CR>', {noremap = true, silent = true})

-- Color highlighter

require'colorizer'.setup()

-- File explorer

g['nnn#set_default_mappings'] = 0
g['nnn#action'] = {
  ['<C-t>'] = 'tab split',
  ['<C-v>'] = 'vsplit',
  ['<C-x>'] = 'split'
}

map('n', '<LEADER>n', ':NnnPicker %<CR>', {noremap = true})
map('n', '<LEADER>N', ':NnnPicker<CR>',   {noremap = true})

-- Fuzzy finder

g.fzf_buffers_jump = 1

map('n', '<LEADER>fb', ':Buffers!<CR>', {noremap = true})
map('n', '<LEADER>ff', ':Files!<CR>',   {noremap = true})
map('n', '<LEADER>fg', ':GFiles!<CR>',  {noremap = true})
map('n', '<LEADER>fs', ':Rg!<CR>',      {noremap = true})

-- Git blame

g.blamer_enabled = 1
g.blamer_show_in_visual_modes = 0
g.blamer_relative_time = 1

-- Language servers

-- TODO auto install all language servers

local servers = {
  "pyright",
  "yamlls"
}

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup{
    on_attach = require('completion').on_attach
  }
end

map('i', '<TAB>',   '<Plug>(completion_smart_tab)',   {})
map('i', '<S-TAB>', '<Plug>(completion_smart_s_tab)', {})

-- Sneak

g['sneak#label'] = 1
cmd 'highlight link Sneak Search'

-- Status line

require('lualine').setup({
  options = {
    theme = 'onedark'
  }
})

-- Tmux navigator

g.tmux_navigator_no_mappings = 1

map('n', '<M-h>', ':TmuxNavigateLeft<CR>',  {noremap = true, silent = true})
map('n', '<M-j>', ':TmuxNavigateDown<CR>',  {noremap = true, silent = true})
map('n', '<M-k>', ':TmuxNavigateUp<CR>',    {noremap = true, silent = true})
map('n', '<M-l>', ':TmuxNavigateRight<CR>', {noremap = true, silent = true})
