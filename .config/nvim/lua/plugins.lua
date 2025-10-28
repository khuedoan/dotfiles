local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    -- {{{ UI
    {
        "https://github.com/navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            require("onedark").setup({
                transparent = true,
            })
            require("onedark").load()
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
        "https://github.com/ibhagwan/fzf-lua",
        dependencies = {
            "https://github.com/elanmed/fzf-lua-frecency.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("fzf-lua").setup({
                "max-perf",
                winopts = {
                    height = 0.5,
                    width = 1,
                    row = 1,
                },
            })
            require("fzf-lua").register_ui_select()
            require("fzf-lua-frecency").setup({
                display_score = false,
            })
        end,
    },

    { "https://github.com/MagicDuck/grug-far.nvim", lazy = true },
    -- }}}

    -- {{{ File manager
    {
        "https://github.com/stevearc/oil.nvim",
        cmd = "Oil",
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name, _)
                        return name == ".."
                    end,
                },
            })
        end,
    },
    -- }}}

    -- {{{ IntelliSense
    {
        "https://github.com/Saghen/blink.cmp",
        dependencies = {
            "https://github.com/neovim/nvim-lspconfig",
        },
        version = "1.*",
        event = "VeryLazy",
        config = function()
            vim.lsp.enable({
                "gopls",
                "lua_ls",
                "nil_ls",
                "pyright",
                "rust_analyzer",
                "terraformls",
                "ts_ls",
            })

            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        procMacro = {
                            ignored = {
                                leptos_macro = {
                                    "server",
                                },
                            },
                        },
                    },
                },
            })

            require("blink.cmp").setup({
                keymap = {
                    preset = "enter",
                },
                cmdline = {
                    keymap = {
                        preset = "super-tab",
                    },
                },
            })
        end,
    },

    -- TODO refactor when Tree-sitter is stable and merged to nvim core
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4767
    {
        "https://github.com/nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "VeryLazy",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "cue",
                    "go",
                    "hcl",
                    "kdl",
                    "nix",
                    "puppet",
                    "python",
                    "rust",
                    "terraform",
                    "tsx",
                    "typescript",
                    "vimdoc",
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

    {
        "https://github.com/windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    -- }}}

    -- {{{ Git
    { "https://github.com/tpope/vim-fugitive", cmd = "Git" },

    {
        "https://github.com/nvim-mini/mini.diff",
        event = "VeryLazy",
        config = function()
            require("mini.diff").setup({})
        end,
    },
    -- }}}

    -- {{{ Motions
    {
        "https://github.com/ggandor/leap.nvim",
        event = "VeryLazy",
        config = function()
            require("leap").opts.safe_labels = ""
            vim.api.nvim_set_hl(0, "LeapLabel", { fg = "yellow", bold = true })
        end,
    },

    {
        "https://github.com/nvim-mini/mini.surround",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "gsa",
                    delete = "gsd",
                    find = "",
                    find_left = "",
                    highlight = "",
                    replace = "gsr",
                },
            })
        end,
    },
    -- }}}

    -- {{{ Miscellaneous
    { "https://github.com/farmergreg/vim-lastplace", event = "BufReadPost" },
    { "https://github.com/nvim-mini/mini.bufremove", lazy = true },

    {
        "https://github.com/tpope/vim-sleuth",
        event = "VeryLazy",
        config = function()
            vim.cmd("silent Sleuth")
        end,
    },
    -- }}}
})
