local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    -- {{{ Libraries
    {
        "https://github.com/nvim-lua/plenary.nvim",
        lazy = true,
    },

    {
        "https://github.com/MunifTanjim/nui.nvim",
        lazy = true,
    },
    -- }}}

    -- {{{ UI
    {
        "https://github.com/navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                transparent = vim.env.TMUX ~= nil,
            })
            require("onedark").load()
        end,
    },

    {
        "https://github.com/nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                },
            })
            vim.opt.showmode = false
        end,
    },

    {
        "https://github.com/akinsho/bufferline.nvim",
        event = "VeryLazy",
        config = function()
            require("bufferline").setup({
                options = {
                    always_show_bufferline = false,
                },
            })
        end,
    },

    {
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "▏",
                    tab_char = "→",
                },
                scope = {
                    enabled = false,
                },
            })
        end,
    },
    -- }}}

    -- {{{ Search
    {
        "https://github.com/junegunn/fzf.vim",
        event = "VeryLazy",
        dependencies = {
            "https://github.com/junegunn/fzf",
        },
        config = function()
            vim.g.fzf_buffers_jump = 1
        end,
    },

    {
        "https://github.com/stevearc/dressing.nvim",
        event = "VeryLazy",
    },
    -- }}}

    -- {{{ File manager
    {
        "https://github.com/stevearc/oil.nvim",
        cmd = "Oil",
        config = function()
            require("oil").setup({
                columns = {},
                view_options = {
                    show_hidden = true,
                },
                win_options = {
                    concealcursor = "nvic",
                },
            })
        end,
    },
    -- }}}

    -- {{{ IntelliSense
    {
        "https://github.com/VonHeikemen/lsp-zero.nvim",
        dependencies = {
            "https://github.com/williamboman/mason.nvim",
            "https://github.com/williamboman/mason-lspconfig.nvim",
            "https://github.com/neovim/nvim-lspconfig",
            "https://github.com/hrsh7th/cmp-nvim-lsp",
            "https://github.com/hrsh7th/nvim-cmp",
            "https://github.com/L3MON4D3/LuaSnip",
        },
        event = "VeryLazy",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
                    "bashls",
                    "bufls",
                    "cssls",
                    "dockerls",
                    "gopls",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "pyright",
                    "rnix",
                    "rust_analyzer",
                    "terraformls",
                    "tflint",
                    "tsserver",
                    "yamlls",
                },
                handlers = {
                    require('lsp-zero').default_setup,
                },
            })

            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm(),
                    ['<Tab>'] = cmp_action.luasnip_supertab(),
                    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
                })
            })

            -- Manually start LSP server after lazy load
            -- TODO use lazy.nvim LazyFile when available
            vim.cmd("filetype detect")
        end,
    },

    {
        "https://github.com/windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    -- {{{ Syntax highlighting
    {
        "https://github.com/nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "dockerfile",
                    "gitcommit",
                    "go",
                    "hcl",
                    "javascript",
                    "json",
                    "json5",
                    "jsonnet",
                    "latex",
                    "lua",
                    "nix",
                    "proto",
                    "python",
                    "rego",
                    "rust",
                    "terraform",
                    "typescript",
                    "yaml",
                },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
    -- }}}

    -- {{{ Git
    {
        "https://github.com/NeogitOrg/neogit",
        cmd = "Neogit",
        config = function()
            require("neogit").setup({
                disable_commit_confirmation = true,
                kind = "split",
                integrations = {
                    diffview = true,
                },
            })
        end,
    },

    {
        "https://github.com/lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
            })
        end,
    },

    {
        "https://github.com/sindrets/diffview.nvim",
        lazy = true,
    },
    -- }}}

    -- {{{ Motions
    {
        "https://github.com/ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("leap").set_default_keymaps()
            vim.api.nvim_set_hl(0, "LeapMatch", {
                fg = "white",
                bold = true,
                nocombine = true,
            })
            vim.api.nvim_set_hl(0, "LeapLabelPrimary", {
                fg = "yellow",
                bold = true,
                nocombine = true,
            })
            vim.api.nvim_set_hl(0, "LeapLabelSecondary", {
                fg = "magenta",
                bold = true,
                nocombine = true,
            })
        end,
    },

    {
        "https://github.com/echasnovski/mini.surround",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "gza",
                    delete = "gzd",
                    find = "gzf",
                    find_left = "gzF",
                    highlight = "gzh",
                    replace = "gzr",
                    update_n_lines = "gzn",
                },
            })
        end,
        keys = {
            { "gz", desc = "Surround" },
        },
    },
    -- }}}

    -- {{{ Keymaps
    {
        "https://github.com/folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").register(require("keymaps"))
        end
    },
    -- }}}

    -- {{{ Miscellaneous
    {
        "https://github.com/farmergreg/vim-lastplace",
        event = "BufReadPost",
    },

    {
        "https://github.com/tpope/vim-sleuth",
        event = "VeryLazy",
    },

    {
        "https://github.com/romainl/vim-cool",
        event = "VeryLazy",
    },

    {
        "https://github.com/numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "https://github.com/echasnovski/mini.bufremove",
        lazy = true,
        config = function()
            require("mini.bufremove").setup()
        end,
    },
    -- }}}
})
