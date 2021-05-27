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
o.shortmess = o.shortmess .. 'c'
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
plug {'hrsh7th/nvim-compe'}
plug {'hrsh7th/vim-vsnip'}
plug {'hrsh7th/vim-vsnip-integ'}
plug {'iamcco/markdown-preview.nvim', run=vim.fn['mkdp#util#install']}
plug {'jiangmiao/auto-pairs'}
plug {'joshdick/onedark.vim'}
plug {'junegunn/fzf'}
plug {'junegunn/fzf.vim'}
plug {'kabouzeid/nvim-lspinstall'}
plug {'kyazdani42/nvim-web-devicons'}
plug {'lukas-reineke/indent-blankline.nvim', branch='lua'} -- TODO use master branch when 0.5 is out
plug {'mcchrish/nnn.vim'}
plug {'neovim/nvim-lspconfig'}
plug {'norcalli/nvim-colorizer.lua'}
plug {'nvim-treesitter/nvim-treesitter'}
plug {'phaazon/hop.nvim'}
plug {'rafamadriz/friendly-snippets'}
plug {'romainl/vim-cool'}
plug {'romgrk/barbar.nvim'}
plug {'tpope/vim-commentary'}
plug {'tpope/vim-fugitive'}
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

require('colorizer').setup()

-- File explorer

g['nnn#replace_netrw'] = 1
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

map('n', '<LEADER>b', ':Buffers!<CR>', {noremap = true})
map('n', '<LEADER>f', ':Files!<CR>\'', {noremap = true})
map('n', '<LEADER>/', ':Rg!<CR>',      {noremap = true})

-- Git

g.blamer_enabled = 1
g.blamer_show_in_visual_modes = 0
g.blamer_relative_time = 1

map('n', '<LEADER>gg', ':Git<SPACE>',      {noremap = true})
map('n', '<LEADER>gs', ':Git<CR>',         {noremap = true})
map('n', '<LEADER>gb', ':Git blame<CR>',   {noremap = true})
map('n', '<LEADER>gc', ':Git commit<CR>',  {noremap = true})
map('n', '<LEADER>gd', ':Gvdiffsplit<CR>', {noremap = true})
map('n', '<LEADER>gl', ':Gclog<CR>',       {noremap = true})
map('n', '<LEADER>gp', ':Git push<CR>',    {noremap = true})
map('n', '<LEADER>gt', ':GFiles!<CR>',     {noremap = true})

-- Hop

map('n', 's', ":lua require'hop'.hint_words()<CR>", {})
map('v', 's', ":lua require'hop'.hint_words()<CR>", {})

-- Language support

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true
    }
}

require('lspinstall').setup()
local servers = require('lspinstall').installed_servers()
for _, server in pairs(servers) do
    require('lspconfig')[server].setup({})
end

require('compe').setup({
    enabled = true;
    autocomplete = true;

    source = {
        buffer = true;
        nvim_lsp = true;
        path = true;
        vsnip = true;
    };
})

-- TODO clean up tab complete

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.call("vsnip#jumpable", {1}) == 1 then
        return t "<Plug>(vsnip-jump-next)"
    elseif vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn["compe#complete"]()
    end
end
_G.s_tab_complete = function()
    if vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    elseif vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

map("i", "<CR>", "compe#confirm('<CR>')",     {expr = true})
map("i", "<Tab>", "v:lua.tab_complete()",     {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()",     {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

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
