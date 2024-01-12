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

    {
        "https://github.com/stevearc/dressing.nvim",
        event = "VeryLazy",
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
    -- }}}

    -- {{{ File manager
    {
        "https://github.com/stevearc/oil.nvim",
        cmd = "Oil",
        config = function()
            local oil = require("oil")
            oil.setup({
                columns = {},
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, bufnr)
                        return name == ".."
                    end,
                },
                win_options = {
                    concealcursor = "nvic",
                },
                keymaps = {
                    ["<Leader><Leader>"] = function()
                        vim.cmd("Files! " .. oil.get_current_dir())
                    end,
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
            "https://github.com/hrsh7th/nvim-cmp",
            "https://github.com/hrsh7th/cmp-nvim-lsp",
            "https://github.com/hrsh7th/cmp-path",
            "https://github.com/hrsh7th/cmp-buffer",
            "https://github.com/L3MON4D3/LuaSnip",
        },
        event = "VeryLazy",
        config = function()
            require("mason").setup({
                PATH = "append", -- Prefer system installed language servers
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- :help lspconfig-all
                    "bashls",
                    "bufls",
                    "gopls",
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "tsserver",
                },
                handlers = {
                    require("lsp-zero").default_setup,
                },
            })

            -- HACK Manually start LSP server after lazy load
            -- TODO use lazy.nvim LazyFile when available
            vim.cmd("filetype detect")

            local cmp = require("cmp")
            local cmp_action = require("lsp-zero").cmp_action()

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm(),
                    ["<Tab>"] = cmp_action.luasnip_supertab(),
                    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
                }),
            })

            require("lsp-zero").on_attach(function(client, bufnr)
                local opts = { buffer = bufnr }
                -- TODO clean up?
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
                vim.keymap.set({ "n", "x" }, "<Leader>=", vim.lsp.buf.format, opts)
                vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            end)
        end,
    },

    {
        "https://github.com/windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },

    -- Additional language support
    -- TODO remove when Tree-sitter is stable and merged to nvim core
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4767
    { "https://github.com/hashivim/vim-terraform", ft = { "terraform", "terraform-vars", "hcl" } },
    { "https://github.com/rodjek/vim-puppet",      ft = { "puppet", "epuppet" } },

    -- Integrate with LLMs (requires Ollama)
    {
        "https://github.com/David-Kunz/gen.nvim",
        cmd = "Gen",
        config = function()
            require("gen").model = "mistral:instruct"
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
    -- }}}

    -- {{{ Motions
    {
        "https://github.com/ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("leap").set_default_keymaps()
            require("leap").opts.safe_labels = {}
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
        event = "VeryLazy",
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
    },
    -- }}}

    -- {{{ Keymaps
    {
        "https://github.com/folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").register(require("keymaps"))
        end,
    },
    -- }}}
})
