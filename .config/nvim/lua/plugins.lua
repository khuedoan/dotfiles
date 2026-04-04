vim.pack.add({
    -- UI
    "https://github.com/navarasu/onedark.nvim",
    "https://github.com/lukas-reineke/indent-blankline.nvim",

    -- Search
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/MagicDuck/grug-far.nvim",

    -- File manager
    "https://github.com/stevearc/oil.nvim",

    -- IntelliSense
    "https://github.com/neovim/nvim-lspconfig",
    { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.x") },
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/nickjvandyke/opencode.nvim",

    -- Git
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/nvim-mini/mini.diff",

    -- Motions
    "https://codeberg.org/andyg/leap.nvim",
    "https://github.com/nvim-mini/mini.surround",

    -- Miscellaneous
    "https://github.com/farmergreg/vim-lastplace",
    "https://github.com/nvim-mini/mini.bufremove",
    "https://github.com/tpope/vim-sleuth",
})

vim.cmd.packadd("nvim.undotree")

require("onedark").setup({
    transparent = true,
})
require("onedark").load()

require("ibl").setup({
    indent = {
        char = "▏",
        tab_char = "→",
    },
    scope = {
        enabled = false,
    },
})

require("fzf-lua").setup({
    "max-perf",
    winopts = {
        height = 0.5,
        width = 1,
        row = 1,
    },
})
require("fzf-lua").register_ui_select()

require("oil").setup({
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
            return name == ".."
        end,
    },
})

vim.lsp.enable({
    -- :help lspconfig-all
    "gopls",
    "lua_ls",
    "markdown_oxide",
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

require("nvim-autopairs").setup()

require("mini.diff").setup({})

require("mini.surround").setup({
    mappings = {
        add = "gz",
        delete = "dz",
        find = "",
        find_left = "",
        highlight = "",
        replace = "rz",
    },
})

require("leap").opts.safe_labels = ""
vim.api.nvim_set_hl(0, "LeapLabel", { fg = "yellow", bold = true })
