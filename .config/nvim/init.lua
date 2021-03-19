-- +---------+
-- | Aliases |
-- +---------+

local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local map = vim.api.nvim_set_keymap
local o = vim.o
local wo = vim.wo

-- +---------+
-- | Options |
-- +---------+

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

-- +----------+
-- | Mappings |
-- +----------+

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

-- +---------+
-- | PLUGINS |
-- +---------+

-- Plugin manager

local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
end

cmd 'packadd paq-nvim'
local plug = require('paq-nvim').paq
plug {'savq/paq-nvim', opt=true}

-- Theme

plug 'joshdick/onedark.vim'

cmd 'autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE'
cmd 'colorscheme onedark'

-- Auto pairs

plug 'jiangmiao/auto-pairs'

-- Buffer line

plug 'romgrk/barbar.nvim'

g.bufferline = {
  animation = false,
  icons = false,
  maximum_padding = 0
}

map('n', '<LEADER><TAB>', ':BufferPick<CR>', {noremap = true, silent = true})

-- Clear search

plug 'romainl/vim-cool'

-- Comment

plug 'tpope/vim-commentary'

-- File explorer

plug 'mcchrish/nnn.vim'

map('n', '<C-n>', ':NnnPicker %<CR>', {noremap = true})

-- Fuzzy search

plug 'junegunn/fzf'
plug 'junegunn/fzf.vim'

g.fzf_buffers_jump = 1

map('n', '<C-f>', ':Rg!<CR>',    {noremap = true})
map('n', '<C-p>', ':Files!<CR>', {noremap = true})

-- Git blame

plug 'APZelos/blamer.nvim'

g.blamer_enabled = 1
g.blamer_show_in_visual_modes = 0
g.blamer_relative_time = 1

-- Git gutter

plug 'airblade/vim-gitgutter'

-- Language packs

plug 'sheerun/vim-polyglot'

-- Language server protocol

plug 'neovim/nvim-lspconfig'
plug 'nvim-lua/completion-nvim'

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

-- Last cursor position

plug 'farmergreg/vim-lastplace'

-- Sneak

plug 'justinmk/vim-sneak'

g['sneak#label'] = 1
cmd 'highlight link Sneak Search'

-- Status line

plug 'hoob3rt/lualine.nvim'

require('lualine').setup({
  options = {
    theme = 'onedark'
  }
})

-- Surround

plug "tpope/vim-surround"

-- Tmux navigator

plug 'christoomey/vim-tmux-navigator'

g.tmux_navigator_no_mappings = 1

map('n', '<M-h>', ':TmuxNavigateLeft<CR>',  {noremap = true, silent = true})
map('n', '<M-j>', ':TmuxNavigateDown<CR>',  {noremap = true, silent = true})
map('n', '<M-k>', ':TmuxNavigateUp<CR>',    {noremap = true, silent = true})
map('n', '<M-l>', ':TmuxNavigateRight<CR>', {noremap = true, silent = true})
