-------------
-- Options --
-------------

vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
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

-- Save and quit

vim.api.nvim_set_keymap('n', '<C-s>', ':write<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-q>', ':quit<CR>',  {noremap = true})

-- Replace

vim.api.nvim_set_keymap('n', '<LEADER>r', ':%s///g<LEFT><LEFT>',  {noremap = true})

-------------
-- Plugins --
-------------

-- Auto install plugin manager

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Plugins configurations

return require'packer'.startup {
  config = {
    auto_reload_compiled = false
  },
  function(use)
    -- Let packer manage itself
    use {
      'wbthomason/packer.nvim',
      config = function()
        vim.cmd "autocmd BufWritePost init.lua source <afile> | PackerCompile"
      end
    }

    -- Status line
    use {
      'shadmansaleh/lualine.nvim', -- TODO check if this is still maintained
      config = function()
        require('lualine').setup({
          options = {
            theme = 'auto'
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

    -- Theme
    use {
      'navarasu/onedark.nvim',
      as = 'theme',
      config = function()
        vim.g.onedark_transparent_background = true
        require('onedark').setup()
      end
    }

    -- Sneak motion
    use {
      'ggandor/lightspeed.nvim',
      after = {
        'theme'
      },
      config = function ()
        require'lightspeed'.setup {
          instant_repeat_fwd_key = ';',
          instant_repeat_bwd_key = ','
        }
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
        vim.api.nvim_set_keymap('n', '<LEADER>bb', ':Buffers!<CR>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>f', ':Files!<CR>\'', {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>F', ':Files! '..vim.fn.expand('%:p:h'), {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>/', ':Rg!<CR>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>gt', ':GFiles!<CR>', {noremap = true})
      end
    }

    -- File explorer
    use {
      'mcchrish/nnn.vim',
      config = function()
        require('nnn').setup({
          set_default_mappings = false,
          session = 'local',
          layout = 'new',
          command = 'nnn -Q',
          action = {
            ['<C-t>'] = 'tab split',
            ['<C-v>'] = 'vsplit',
            ['<C-x>'] = 'split'
          }
        })
        vim.api.nvim_set_keymap('n', '<LEADER>n', ':NnnPicker<CR>', {noremap = true})
      end
    }

    -- Show indent line
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup {
          char = "▏",
          show_first_indent_level = false,
          show_trailing_blankline_indent = false,
        }
      end
    }

    -- Syntax highlighting and objects
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        "godlygeek/tabular",
        "hashivim/vim-terraform", -- TODO fix comment in HCL on nvim-treesitter up stream
        "tpope/vim-sleuth",
        "romgrk/nvim-treesitter-context"
      },
      run = ':TSUpdate',
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = "maintained",
          highlight = {
            enable = true
          }
        }
        require'treesitter-context'.setup{}
      end
    }

    -- Buffer line
    use {
      'akinsho/nvim-bufferline.lua',
      requires = {
        'kyazdani42/nvim-web-devicons'
      },
      config = function()
        require("bufferline").setup({})
        vim.api.nvim_set_keymap('n', '<C-l>', ':BufferLineCycleNext<CR>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<C-h>', ':BufferLineCyclePrev<CR>', {noremap = true})
      end
    }

    -- Language server protocol
    use {
      'williamboman/nvim-lsp-installer',
      requires = {
        'neovim/nvim-lspconfig',
      },
      run = function()
        local required_servers = {
          "dockerls",
          "gopls",
          "pylsp",
          "pyright",
          "rust_analyzer",
          "sumneko_lua",
          "terraformls",
          "tsserver",
          "yamlls",
        }

        require "nvim-lsp-installer.ui.status-win"().open()
        local lsp_installer_servers = require'nvim-lsp-installer.servers'
        for _, required_server in pairs(required_servers) do
          local _, server = lsp_installer_servers.get_server(required_server)
          if not server:is_installed() then
            server:install()
          end
        end
      end,
      config = function()
        local lsp_installer = require("nvim-lsp-installer")

        lsp_installer.on_server_ready(function(server)
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
            buf_set_keymap('n', '<space>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
          end

          server:setup({
            on_attach = on_attach()
          })

          vim.cmd [[ do User LspAttachBuffers ]]
        end)
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

        local t = function(str)
          return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        local check_back_space = function()
            local col = vim.fn.col('.') - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
        end

        -- Use (s-)tab to:
        --- move to prev/next item in completion menuone
        --- jump to prev/next snippet's placeholder
        _G.tab_complete = function()
          if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
          elseif vim.fn['vsnip#available'](1) == 1 then
            return t "<Plug>(vsnip-expand-or-jump)"
          elseif check_back_space() then
            return t "<Tab>"
          else
            return vim.fn['compe#complete']()
          end
        end
        _G.s_tab_complete = function()
          if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
          elseif vim.fn['vsnip#jumpable'](-1) == 1 then
            return t "<Plug>(vsnip-jump-prev)"
          else
            -- If <S-Tab> is not working in your terminal, change it to <C-h>
            return t "<S-Tab>"
          end
        end

        vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
        vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
        vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
      end
    }

    -- Debug Adapter Protocol
    use {
      'mfussenegger/nvim-dap',
      config = function ()
        -- TODO add debug adapter for Python, Go and Rust
      end
    }

    -- Common UNIX commands
    use {
      'tpope/vim-eunuch'
    }

    -- Formatter
    use {
      'sbdchd/neoformat',
      config = function()
        vim.g.neoformat_basic_format_trim = 1
        vim.api.nvim_set_keymap("v", "=", ":Neoformat<CR>", { noremap = true })
      end
    }

    -- Scrollbar
    use {
      'dstein64/nvim-scrollview'
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end
}
