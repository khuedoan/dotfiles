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
        "https://github.com/kyazdani42/nvim-web-devicons",
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
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                show_first_indent_level = false,
                show_trailing_blankline_indent = false,
                use_treesitter = true,
            })
        end,
    },

    {
        "https://github.com/j-hui/fidget.nvim",
        event = "VeryLazy",
        config = function()
            require("fidget").setup({
                text = {
                    spinner = "dots",
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
        "stevearc/oil.nvim",
        cmd = "Oil",
        config = function()
            require("oil").setup({
                columns = {},
                view_options = {
                    show_hidden = true,
                },
            })
        end,
    },
    -- }}}

    -- {{{ IntelliSense
    {
        "https://github.com/williamboman/mason-lspconfig.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "https://github.com/williamboman/mason.nvim",
            "https://github.com/neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "bufls",
                    "cssls",
                    "dockerls",
                    "gopls",
                    "grammarly",
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
            })

            local on_attach = function(client, bufnr)
                -- TODO clean up
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
                vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<space>=", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    })
                end,
            })
        end,
    },
    -- }}}

    -- {{{ Completion
    {
        "https://github.com/hrsh7th/nvim-cmp",
        event = "VeryLazy",
        dependencies = {
            "https://github.com/hrsh7th/cmp-buffer",
            "https://github.com/hrsh7th/cmp-nvim-lsp",
            "https://github.com/hrsh7th/cmp-path",
            "https://github.com/saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-l>"] = cmp.mapping(function()
                        vim.api.nvim_feedkeys(
                            vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)),
                            "n",
                            true
                        )
                    end),
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "lua_snip" },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                experimental = {
                    ghost_text = false, -- Conflict with Copilot
                },
            })
        end,
    },

    {
        "https://github.com/L3MON4D3/LuaSnip",
        event = "VeryLazy",
        dependencies = {
            "https://github.com/rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    {
        "https://github.com/windwp/nvim-autopairs",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    {
        "https://github.com/github/copilot.vim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.keymap.set("i", "<Plug>(vimrc:copilot-dummy-map)", "copilot#Accept()", { silent = true, expr = true })
        end,
    },
    -- }}}

    -- {{{ Syntax highlighting
    {
        "https://github.com/nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
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

    -- {{{ Formatting
    {
        "https://github.com/sbdchd/neoformat",
        cmd = "Neoformat",
        config = function()
            vim.g.neoformat_try_node_exe = true
        end,
    },
    -- }}}

    -- {{{ Debugging
    -- TODO
    {
        "https://github.com/mfussenegger/nvim-dap",
        lazy = true,
    },

    {
        "https://github.com/rcarriga/nvim-dap-ui",
        lazy = true,
    },

    {
        "https://github.com/ravenxrz/DAPInstall.nvim",
        lazy = true,
    },
    -- }}}

    -- {{{ Markdown
    {
        "https://github.com/iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = "cd app && yarn install",
    },

    {
        "https://github.com/jakewvincent/mkdnflow.nvim",
        ft = "markdown",
        config = function()
            require("mkdnflow").setup({
                to_do = {
                    symbols = { " ", "-", "x" },
                },
            })
        end,
    },
    -- }}}

    -- {{{ Git
    {
        "https://github.com/TimUntersberger/neogit",
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
        "https://github.com/pwntester/octo.nvim",
        cmd = "Octo",
        config = function()
            require("octo").setup()
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
        cmd = {
            "DiffviewFileHistory",
        },
    },
    -- }}}

    -- {{{ Motions
    {
        "https://github.com/ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("leap").set_default_keymaps()
            vim.api.nvim_set_hl(0, "LeapBackdrop", {
                link = "Comment",
            })
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
    -- }}}

    -- {{{ Keymaps
    {
        "https://github.com/folke/which-key.nvim",
        lazy = true,
    },

    {
        "https://github.com/mrjones2014/legendary.nvim",
        cmd = "Legendary",
        config = function()
            require("legendary").setup({
                which_key = {
                    auto_register = true,
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
        event = { "BufReadPost", "BufNewFile" },
    },

    {
        "https://github.com/romainl/vim-cool",
        event = "VeryLazy",
    },

    {
        "https://github.com/tpope/vim-eunuch",
        event = "VeryLazy",
    },

    {
        "https://github.com/mbbill/undotree",
        cmd = {
            "UndotreeShow",
            "UndotreeToggle",
        },
    },

    {
        "https://github.com/numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup({})
        end,
    },

    {
        "https://github.com/christoomey/vim-tmux-navigator",
        event = "VeryLazy",
        config = function()
            vim.g.tmux_navigator_no_mappings = 1
            vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<cr>", { silent = true })
            vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<cr>", { silent = true })
            vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<cr>", { silent = true })
            vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<cr>", { silent = true })
        end,
    },

    {
        "echasnovski/mini.bufremove",
        lazy = true,
        config = function()
            require("mini.bufremove").setup()
        end,
    },
    -- }}}
})
