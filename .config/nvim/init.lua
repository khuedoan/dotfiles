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

plug {'joshdick/onedark.vim'}

cmd 'autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE'
cmd 'colorscheme onedark'

-- Auto pairs

plug {'jiangmiao/auto-pairs'}

-- Buffer line

plug {'romgrk/barbar.nvim'}

g.bufferline = {
  animation = false,
  icons = false,
  maximum_padding = 0
}

map('n', '<LEADER><TAB>', ':BufferPick<CR>', {noremap = true, silent = true})

-- Clear search

plug {'romainl/vim-cool'}

-- Comment

plug {'tpope/vim-commentary'}

-- File explorer

plug {'mcchrish/nnn.vim'}

map('n', '<C-n>', ':NnnPicker %<CR>', {noremap = true})

-- Fuzzy search

plug {'junegunn/fzf'}
plug {'junegunn/fzf.vim'}

g.fzf_buffers_jump = 1

map('n', '<C-f>', ':Rg!<CR>',    {noremap = true})
map('n', '<C-p>', ':Files!<CR>', {noremap = true})

-- Git blame

plug {'APZelos/blamer.nvim'}

g.blamer_enabled = 1
g.blamer_show_in_visual_modes = 0
g.blamer_relative_time = 1

-- Git gutter

plug {'airblade/vim-gitgutter'}

-- Language packs

plug {'sheerun/vim-polyglot'}

-- Language server client

plug {'neovim/nvim-lspconfig'}

-- TODO

-- Last cursor position

plug {'farmergreg/vim-lastplace'}

-- Sneak

plug {'justinmk/vim-sneak'}

g['sneak#label'] = 1

-- Status line

plug 'hoob3rt/lualine.nvim'

require('lualine').status({
  options = {
    theme = 'onedark'
  }
})

-- Tmux navigator

plug {'christoomey/vim-tmux-navigator'}

g.tmux_navigator_no_mappings = 1

map('n', '<M-h>', ':TmuxNavigateLeft<CR>',  {noremap = true, silent = true})
map('n', '<M-j>', ':TmuxNavigateDown<CR>',  {noremap = true, silent = true})
map('n', '<M-k>', ':TmuxNavigateUp<CR>',    {noremap = true, silent = true})
map('n', '<M-l>', ':TmuxNavigateRight<CR>', {noremap = true, silent = true})

-- +--------------+
-- | Experimental |
-- +--------------+

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = {
  "pyright",
  "rust_analyzer",
  "sumneko_lua",
  "terraformls",
  "tsserver",
  "yamlls"
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
