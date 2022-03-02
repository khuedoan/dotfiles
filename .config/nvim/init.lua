-------------
-- Options --
-------------

vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.guifont = 'FiraCode Nerd Font Mono:h9.5'
vim.opt.hidden = true
vim.opt.inccommand = 'nosplit'
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
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
      'nvim-lualine/lualine.nvim',
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
      'TimUntersberger/neogit',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      keys = {
        '<LEADER>gs'
      },
      cmd = {
        'Neogit'
      },
      config = function()
        require('neogit').setup {
          disable_commit_confirmation = true,
          disable_context_highlighting = true
        }

        vim.api.nvim_set_keymap('n', '<LEADER>gs', ':Neogit kind=split<CR>', {noremap = true})
      end
    }

    -- Theme
    use {
      'navarasu/onedark.nvim',
      as = 'theme',
      config = function()
        require'onedark'.setup {
          transparent = true
        }
        require'onedark'.load()
      end
    }

    -- Sneak motion
    use {
      'ggandor/lightspeed.nvim',
      after = {
        'theme'
      },
      keys = {
        'S',
        's'
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
      cmd = {
        'ColorizerToggle'
      },
      config = function()
        require('colorizer').setup()
      end
    }

    -- Star search on visual selection
    use {
      'bronson/vim-visual-star-search',
      keys = {
        {'v', '*'}
      }
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
      },
      config = function()
        vim.api.nvim_set_keymap('n', '<LEADER>mp', ':MarkdownPreviewToggle<CR>', {noremap = true, silent = true})
      end
    }

    -- Auto pair
    use {
      'jiangmiao/auto-pairs'
    }

    -- Comment
    use {
      'tpope/vim-commentary',
      keys = {
        {'n', 'gc'},
        {'v', 'gc'}
      },
      cmd = {
        'Commentary'
      }
    }

    -- Auto hide search highlight
    use {
      'romainl/vim-cool'
    }

    -- Fuzzy search
    use {
      'junegunn/fzf.vim',
      requires = {
        'junegunn/fzf'
      },
      config = function()
        vim.g.fzf_buffers_jump = 1
        vim.api.nvim_set_keymap('n', '<LEADER><TAB>', ':Buffers!<CR>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>ff', ':Files!<CR>\'', {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>f.', ':Files! '..vim.fn.expand('%:p:h'), {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>f/', ':Rg!<CR>', {noremap = true})
        vim.api.nvim_set_keymap('n', '<LEADER>fg', ':GFiles!<CR>', {noremap = true})
      end
    }

    -- File explorer
    use {
      'mcchrish/nnn.vim',
      keys = {
        '<LEADER>n'
      },
      cmd = {
        'NnnPicker'
      },
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
        "tpope/vim-sleuth"
      },
      run = ':TSUpdate',
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = "maintained",
          highlight = {
            enable = true
          }
        }
      end
    }

    -- Legacy language support without treesitter
    -- TODO remove these after nvim 0.6
    use {
      "rodjek/vim-puppet",
      ft = {
        'puppet'
      },
    }

    use {
      "hashivim/vim-terraform", -- TODO fix comment in HCL on nvim-treesitter up stream
      ft = {
        'hcl',
        'terraform'
      },
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
          "ansiblels",
          "bashls",
          "diagnosticls",
          "dockerls",
          "gopls",
          "jsonls",
          "pylsp",
          "pyright",
          "rust_analyzer",
          "sqls",
          "sumneko_lua",
          "terraformls",
          "tflint",
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
      'hrsh7th/nvim-cmp',
      requires = {
        -- sources
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',

        -- snippets
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
        'rafamadriz/friendly-snippets',

        -- pictograms
        'onsails/lspkind-nvim'
      },
      config = function()
        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local feedkey = function(key, mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end

        local cmp = require'cmp'

        cmp.setup {
          formatting = {
            format = require'lspkind'.cmp_format(),
            with_text = true,
          },
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = {
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
              elseif has_words_before() then
                cmp.complete()
              else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function()
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
              end
            end, { "i", "s" }),
          },
          sources = cmp.config.sources(
            {
              { name = 'nvim_lsp' },
              { name = 'vsnip' },
            },
            {
              { name = 'buffer' },
            }
          )
        }

        -- Use buffer source for `/`
        cmp.setup.cmdline('/', {
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(':', {
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })
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

    -- Switch between single-line and multiline forms of code
    use {
      'AndrewRadev/splitjoin.vim',
      keys = {
        'gS',
        'gJ'
      },
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end
}
