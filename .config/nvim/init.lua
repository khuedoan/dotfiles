-- Options

vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.guifont = "FiraCode Nerd Font Mono:h9.5"
vim.opt.hidden = true
vim.opt.inccommand = "nosplit"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.shortmess = vim.opt.shortmess + "c"
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 100

-- Auto commands

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = vim.highlight.on_yank,
})

-- Leader

vim.g.mapleader = " "

-- Copy and paste with system clipboard

vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })

-- Save and quit

vim.keymap.set("n", "<C-s>", ":write<cr>", { silent = true })
vim.keymap.set("n", "<C-q>", ":quit<cr>", { silent = true })

-- Buffers

vim.keymap.set("n", "<leader>bd", ":bdelete<cr>", { silent = true })

-- Replace

vim.keymap.set("n", "<leader>r", ":%s///g<LEFT><LEFT>", { silent = true })

-- Auto install plugin manager

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })

    vim.api.nvim_command("packadd packer.nvim")
end

-- Plugins configurations

return require("packer").startup({
    function(use)
        -- Let packer manage itself
        use({
            "wbthomason/packer.nvim",
        })

        -- Status line
        use({
            "nvim-lualine/lualine.nvim",
            config = function()
                require("lualine").setup({
                    options = {
                        theme = "auto",
                        globalstatus = true,
                    },
                })
            end,
        })

        -- Git
        use({
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
            },
            config = function()
                require("gitsigns").setup({})
            end,
        })

        use({
            "APZelos/blamer.nvim",
            config = function()
                vim.g.blamer_enabled = 1
                vim.g.blamer_show_in_visual_modes = 0
                vim.g.blamer_relative_time = 1
            end,
        })

        use({
            "TimUntersberger/neogit",
            requires = {
                "nvim-lua/plenary.nvim",
                "sindrets/diffview.nvim",
            },
            keys = {
                "<leader>g",
            },
            cmd = {
                "Neogit",
            },
            config = function()
                require("neogit").setup({
                    disable_commit_confirmation = true,
                    disable_context_highlighting = true,
                    integrations = {
                        diffview = true,
                    },
                })

                vim.keymap.set("n", "<leader>gs", ":Neogit kind=split<cr>", { silent = true })
            end,
        })

        use({
            "tpope/vim-fugitive",
        })

        -- Theme
        use({
            "navarasu/onedark.nvim",
            as = "theme",
            config = function()
                require("onedark").setup({
                    transparent = vim.env.TMUX ~= nil,
                })
                require("onedark").load()
            end,
        })

        -- Sneak motion
        use({
            "ggandor/lightspeed.nvim",
            after = {
                "theme",
            },
            keys = {
                "S",
                "s",
            },
            config = function()
                require("lightspeed").setup({
                    instant_repeat_fwd_key = ";",
                    instant_repeat_bwd_key = ",",
                })
            end,
        })

        -- Colorizer
        use({
            "norcalli/nvim-colorizer.lua",
            cmd = {
                "ColorizerToggle",
            },
            config = function()
                require("colorizer").setup()
            end,
        })

        -- Star search on visual selection
        use({
            "bronson/vim-visual-star-search",
            keys = {
                { "v", "*" },
            },
        })

        -- Tmux navigator
        use({
            "christoomey/vim-tmux-navigator",
            config = function()
                vim.g.tmux_navigator_no_mappings = 1

                vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<cr>", { silent = true })
                vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<cr>", { silent = true })
                vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<cr>", { silent = true })
                vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<cr>", { silent = true })
            end,
        })

        -- Restore cursor position
        use("farmergreg/vim-lastplace")

        -- Markdown preview
        use({
            "iamcco/markdown-preview.nvim",
            run = function()
                vim.fn["mkdp#util#install"](0)
            end,
            ft = {
                "markdown",
            },
            config = function()
                vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>", { silent = true })
            end,
        })

        -- Auto pair
        use({
            "jiangmiao/auto-pairs",
        })

        -- Comment
        use({
            "tpope/vim-commentary",
            keys = {
                { "n", "gc" },
                { "v", "gc" },
            },
            cmd = {
                "Commentary",
            },
        })

        -- Auto hide search highlight
        use({
            "romainl/vim-cool",
        })

        -- Fuzzy search
        use({
            "junegunn/fzf.vim",
            requires = {
                "junegunn/fzf",
            },
            config = function()
                vim.g.fzf_buffers_jump = 1
                vim.keymap.set("n", "<leader><leader>", ":GFiles!<cr>'", { silent = true })
                vim.keymap.set("n", "<leader>ff", ":Files!<cr>'", { silent = true })
                vim.keymap.set("n", "<leader>f.", ":Files! " .. vim.fn.expand("%:p:h", { silent = true }))

                vim.keymap.set("n", "<leader>/", ":Rg!<cr>", { silent = true })

                vim.keymap.set("n", "<leader>bb", ":Buffers!<cr>", { silent = true })
                vim.keymap.set("n", "<leader>,", ":Buffers!<cr>", { silent = true })
            end,
        })

        -- File explorer
        use({
            "mcchrish/nnn.vim",
            config = function()
                require("nnn").setup({
                    replace_netrw = true,
                    set_default_mappings = false,
                    session = "local",
                    layout = "new",
                    command = "nnn -Q",
                    action = {
                        ["<C-t>"] = "tab split",
                        ["<C-v>"] = "vsplit",
                        ["<C-x>"] = "split",
                    },
                })
                vim.keymap.set("n", "<leader>n", ":NnnPicker<cr>", { silent = true })
            end,
        })

        -- Show indent line
        use({
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("indent_blankline").setup({
                    char = "▏",
                    show_first_indent_level = false,
                    show_trailing_blankline_indent = false,
                })
            end,
        })

        -- Syntax highlighting and objects
        use({
            "nvim-treesitter/nvim-treesitter",
            requires = {
                "godlygeek/tabular",
                "tpope/vim-sleuth",
            },
            run = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = {
                        "bash",
                        "dockerfile",
                        "go",
                        "hcl",
                        "javascript",
                        "json",
                        "json5",
                        "latex",
                        "lua",
                        "nix",
                        "python",
                        "rust",
                        "svelte",
                        "typescript",
                        "yaml",
                    },
                    highlight = {
                        enable = true,
                    },
                })
            end,
        })

        -- Legacy language support without treesitter
        -- TODO remove these after nvim 0.6
        use({
            "rodjek/vim-puppet",
            ft = {
                "puppet",
            },
        })

        use({
            "hashivim/vim-terraform", -- TODO fix comment in HCL on nvim-treesitter up stream
            ft = {
                "hcl",
                "terraform",
            },
        })

        -- Buffer line
        use({
            "akinsho/nvim-bufferline.lua",
            requires = {
                "kyazdani42/nvim-web-devicons",
            },
            config = function()
                require("bufferline").setup({})
                vim.keymap.set("n", "<C-l>", ":BufferLineCycleNext<cr>", { silent = true })
                vim.keymap.set("n", "<C-h>", ":BufferLineCyclePrev<cr>", { silent = true })
            end,
        })

        -- Language server protocol
        use({
            "junnplus/lsp-setup.nvim",
            requires = {
                "neovim/nvim-lspconfig",
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
            },
            config = function()
                require("lsp-setup").setup({
                    servers = {
                        ansiblels = {},
                        bashls = {},
                        diagnosticls = {},
                        dockerls = {},
                        gopls = {},
                        jsonls = {},
                        ltex = {},
                        pylsp = {},
                        pyright = {},
                        rust_analyzer = {},
                        svelte = {},
                        sqls = {},
                        sumneko_lua = {},
                        terraformls = {},
                        tflint = {},
                        tsserver = {},
                        yamlls = {},
                    },
                    on_attach = function()
                        -- Disable format on save
                        -- require('nvim-lsp-setup.utils').format_on_save(client)
                    end,
                })
            end,
        })

        -- Autocomplete
        use({
            "hrsh7th/nvim-cmp",
            requires = {
                -- sources
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",

                -- snippets
                "hrsh7th/cmp-vsnip",
                "hrsh7th/vim-vsnip",
                "rafamadriz/friendly-snippets",

                -- pictograms
                "onsails/lspkind-nvim",
            },
            config = function()
                local has_words_before = function()
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0
                        and not vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
                end

                local feedkey = function(key, mode)
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
                end

                local cmp = require("cmp")

                cmp.setup({
                    formatting = {
                        format = require("lspkind").cmp_format(),
                        with_text = true,
                    },
                    snippet = {
                        expand = function(args)
                            vim.fn["vsnip#anonymous"](args.body)
                        end,
                    },
                    mapping = {
                        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                        ["<C-y>"] = cmp.config.disable,
                        ["<C-e>"] = cmp.mapping({
                            i = cmp.mapping.abort(),
                            c = cmp.mapping.close(),
                        }),
                        ["<cr>"] = cmp.mapping.confirm({ select = true }),
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
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "vsnip" },
                    }, {
                        { name = "buffer" },
                    }),
                })

                -- Use buffer source for `/`
                cmp.setup.cmdline("/", {
                    sources = {
                        { name = "buffer" },
                    },
                })

                -- Use cmdline & path source for ':'
                cmp.setup.cmdline(":", {
                    sources = cmp.config.sources({
                        { name = "path" },
                    }, {
                        { name = "cmdline" },
                    }),
                })
            end,
        })

        use({
            "brymer-meneses/grammar-guard.nvim",
            ft = {
                "markdown",
            },
            config = function()
                require("grammar-guard").init()
            end,
        })

        -- Common UNIX commands
        use({
            "tpope/vim-eunuch",
        })

        -- Formatter
        use({
            "sbdchd/neoformat",
            config = function()
                vim.g.neoformat_basic_format_trim = 1
                vim.keymap.set("v", "=", ":Neoformat<cr>", { silent = true })
            end,
        })

        -- Switch between single-line and multiline forms of code
        use({
            "AndrewRadev/splitjoin.vim",
            keys = {
                "gS",
                "gJ",
            },
        })

        use({
            "akinsho/toggleterm.nvim",
            keys = {
                "<C-`>",
            },
            config = function()
                require("toggleterm").setup({
                    open_mapping = "<C-`>",
                    shade_terminals = false,
                })
            end,
        })

        if packer_bootstrap then
            require("packer").sync()
        end
    end,
})
