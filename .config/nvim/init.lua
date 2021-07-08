-------------
-- Options --
-------------

vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.inccommand = 'nosplit'
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 1
vim.opt.shiftwidth = 4
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 100

--------------
-- Mappings --
--------------

-- Leader

vim.g.mapleader = ' '

-- Copy and paste with system clipboard

vim.api.nvim_set_keymap('v', '<C-c>', '"+y',    {noremap = true})
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', {noremap = true})

-- Replace

vim.api.nvim_set_keymap('n', '<LEADER>r', ':%s///g<LEFT><LEFT>',  {noremap = true})

-------------
-- Plugins --
-------------

-- Auto install plugin manager

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Plugins configurations

return require('packer').startup({function()
  -- Let packer manage itself
  use {
    'wbthomason/packer.nvim',
    config = function()
      vim.cmd "autocmd BufWritePost init.lua PackerCompile"
    end
  }

  -- Status line
  use {
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'onedark'
        }
      })
    end
  }

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup({
      })
    end
  }

  use {
    'APZelos/blamer.nvim',
    config = function()
      vim.g.blamer_enabled = 1
      vim.g.blamer_show_in_visual_modes = 0
      vim.g.blamer_relative_time = 1
    end
  }

  use {
    'tpope/vim-fugitive',
    config = function()
      vim.api.nvim_set_keymap('n', '<LEADER>gg', ':Git<SPACE>',      {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gs', ':Git<CR>',         {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gb', ':Git blame<CR>',   {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gc', ':Git commit<CR>',  {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gd', ':Gvdiffsplit<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gl', ':Gclog<CR>',       {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gp', ':Git push<CR>',    {noremap = true})
    end
  }

  -- Sneak motion
  use 'ggandor/lightspeed.nvim'

  -- Theme
  use {
    'ful1e5/onedark.nvim',
    config = function()
      require('onedark').setup({
        transparent = true
      })
    end
  }

  -- Colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  }

  -- Star search on visual selection
  use {
    'bronson/vim-visual-star-search'
  }

  -- Tmux navigator
  use {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.api.nvim_set_keymap('n', '<M-h>', ':TmuxNavigateLeft<CR>',  {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<M-j>', ':TmuxNavigateDown<CR>',  {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<M-k>', ':TmuxNavigateUp<CR>',    {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<M-l>', ':TmuxNavigateRight<CR>', {noremap = true, silent = true})
    end
  }

  -- Restore cursor position
  use 'farmergreg/vim-lastplace'

  -- Markdown preview
  use {
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install'](0)
    end,
    ft = {
      'markdown'
    }
  }

  -- Auto pair
  use 'jiangmiao/auto-pairs'

  -- Comment
  use 'tpope/vim-commentary'

  -- Auto hide search highlight
  use 'romainl/vim-cool'

  -- Fuzzy search
  use {
    'junegunn/fzf.vim',
    requires = {
      'junegunn/fzf'
    },
    config = function()
      vim.g.fzf_buffers_jump = 1
      vim.api.nvim_set_keymap('n', '<LEADER>b',  ':Buffers!<CR>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>f',  ':Files!<CR>\'', {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>/',  ':Rg!<CR>',      {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>gt', ':GFiles!<CR>',  {noremap = true})
    end
  }

  -- File explorer
  use {
    'mcchrish/nnn.vim',
    config = function()
      require('nnn').setup({
        set_default_mappings = false,
        session = 'local',
        action = {
          ['<C-t>'] = 'tab split',
          ['<C-v>'] = 'vsplit',
          ['<C-x>'] = 'split'
        }
      })
      vim.api.nvim_set_keymap('n', '<LEADER>n', ':NnnPicker<CR>',       {noremap = true})
      vim.api.nvim_set_keymap('n', '<LEADER>N', ':NnnPicker %:p:h<CR>', {noremap = true})
    end
  }

  -- Show indent line
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_char = "▏"
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
    end
  }

  -- Set indent options automatically
  use "tpope/vim-sleuth"

  -- Syntax highlighting and objects
  -- TODO use tree-sitter on neovim 0.6
  -- use {
  --   'nvim-treesitter/nvim-treesitter',
  --   run = ':TSUpdate',
  --   config = function()
  --     require'nvim-treesitter.configs'.setup {
  --       ensure_installed = "maintained",
  --       highlight = {
  --         enable = true
  --       }
  --     }
  --   end
  -- }
  use 'sheerun/vim-polyglot'

  -- Buffer line
  use {
    'romgrk/barbar.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      vim.g.bufferline = {
        animation = false,
        maximum_padding = 0
      }
    end
  }

  -- Language server protocol
  use {
    'kabouzeid/nvim-lspinstall',
    requires = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('lspinstall').setup()

      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
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
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      end

      local servers = require('lspinstall').installed_servers()
      for _, server in pairs(servers) do
        require('lspconfig')[server].setup {
          on_attach = on_attach
        }
      end
    end
  }

  -- Autocomplete
  use {
    "hrsh7th/nvim-compe",
    requires = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'rafamadriz/friendly-snippets',
    },
    config = function()
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

      vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
    end,
  }

  -- Formatter
  use {
    'sbdchd/neoformat',
    config = function()
      vim.g.neoformat_basic_format_trim = 1
    end
  }
end
})
