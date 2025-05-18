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
        end,
    },

    {
        "https://github.com/MagicDuck/grug-far.nvim",
        version = "v1.6.3", -- TODO use latest version on nvim 0.11
        lazy = true,
        config = function()
            require("grug-far").setup({})
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
            })
        end,
    },

    {
        "https://github.com/ThePrimeagen/harpoon",
        branch = "harpoon2",
        event = "VeryLazy",
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            for i = 1, 5 do
                vim.keymap.set("n", "<C-" .. i .. ">", function()
                    harpoon:list():select(i)
                end)
            end
        end,
    },
    -- }}}

    -- {{{ IntelliSense
    {
        "https://github.com/Saghen/blink.cmp",
        version = "v0.*",
        event = "VeryLazy",
        config = function()
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

    {
        "https://github.com/neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            -- Requires language servers to be already installed
            -- :help lspconfig-all
            local servers = {
                gopls = {},
                lua_ls = {},
                nil_ls = {},
                pyright = {},
                rust_analyzer = {},
                terraformls = {},
                ts_ls = {},
            }

            local lspconfig = require("lspconfig")
            for server, config in pairs(servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end

            -- HACK manually start LSP server after lazy load
            vim.cmd("filetype detect")
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
    {
        "https://github.com/tpope/vim-fugitive",
        cmd = "Git",
    },

    {
        "https://github.com/echasnovski/mini.diff",
        event = "VeryLazy",
        config = function()
            require("mini.diff").setup({})
        end,
    },
    -- }}}

    -- {{{ Motions
    {
        "https://github.com/folke/flash.nvim",
        event = "VeryLazy",
        config = function()
            require("flash").setup({
                modes = {
                    search = {
                        enabled = true,
                    },
                    char = {
                        enabled = false,
                    },
                },
                highlight = {
                    groups = {
                        label = "Question",
                    },
                },
            })
        end,
    },

    {
        "https://github.com/echasnovski/mini.surround",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({})
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
        config = function()
            vim.cmd("silent Sleuth")
        end,
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
        keys = require("keymaps"),
    },
    -- }}}
})
