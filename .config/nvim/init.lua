vim.loader.enable() -- fast load dark magic

vim.opt.ignorecase = true     -- ignore case in search patterns
vim.opt.smartcase = true      -- smart case
vim.opt.smartindent = true    -- make indenting smarter again
vim.opt.splitbelow = true     -- force all horizontal splits to go below current window
vim.opt.splitright = true     -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false      -- creates a swapfile
vim.opt.undofile = true       -- enable persistent undo
vim.opt.expandtab = true      -- convert tabs to spaces
vim.opt.shiftwidth = 4        -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4           -- insert 4 spaces for a tab
vim.opt.cursorline = true     -- highlight the current line
vim.opt.number = true         -- set numbered lines
vim.opt.relativenumber = true -- show relative line number
vim.opt.signcolumn = "yes"    -- always show the sign column, otherwise it would shift the text each time
vim.opt.scrolloff = 3         -- minimal number of screen lines to keep above and below the cursor
vim.opt.laststatus = 0        -- disable statusline

vim.pack.add({
    "https://github.com/navarasu/onedark.nvim",
})

require("onedark").setup({
    transparent = true,
})
require("onedark").load()

vim.schedule(function()
    vim.g.mapleader = " "
    local map = vim.keymap.set

    map("x", "<Leader>y", '"+y')
    map("n", "<Leader>yF", "<Cmd>let @+ = expand('%:p:~')<CR>")
    map("n", "<Leader>yf", "<Cmd>let @+ = expand('%')<CR>")
    map("n", "<Leader>u", "<Cmd>Undotree<CR>")

    vim.cmd.packadd("nvim.undotree")
    vim.pack.add({
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        "https://github.com/ibhagwan/fzf-lua",
        "https://github.com/MagicDuck/grug-far.nvim",
        "https://github.com/stevearc/oil.nvim",
        "https://github.com/neovim/nvim-lspconfig",
        { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.x") },
        "https://github.com/windwp/nvim-autopairs",
        "https://github.com/tpope/vim-fugitive",
        "https://github.com/nvim-mini/mini.diff",
        "https://codeberg.org/andyg/leap.nvim",
        "https://github.com/nvim-mini/mini.surround",
        "https://github.com/nvim-mini/mini.bufremove",
        "https://github.com/tpope/vim-sleuth",
    })

    map("n", "<Leader>bd", function()
        require("mini.bufremove").delete()
    end)

    map("n", "<Leader>gs", "<Cmd>Git<CR>")
    map("n", "<Leader>gd", "<Cmd>Git diff<CR>")
    map("n", "<Leader>gD", "<Cmd>Git diff --staged<CR>")
    map("n", "<Leader>gb", "<Cmd>Git blame<CR>")
    map("n", "<Leader>gl", "<Cmd>Git log<CR>")
    map("n", "<Leader>ghb", "<Cmd>silent !gh browse %<CR>")
    map("n", "<Leader>ghr", "<Cmd>silent !gh repo view --web<CR>")

    map("n", "<Leader>sr", function()
        require("grug-far").open({
            prefills = {
                paths = vim.fn.expand("%"),
            },
        })
    end)
    map("n", "<Leader>sR", function()
        require("grug-far").grug_far({})
    end)

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
    map("n", "<Leader><Leader>", "<Cmd>FzfLua combine pickers=buffers;files<CR>")
    map("n", "<Leader>fg", "<Cmd>FzfLua git_files<CR>")
    map("n", "<Leader>,", "<Cmd>FzfLua buffers<CR>")
    map("n", "<Leader>/", "<Cmd>FzfLua grep_project<CR>")
    map("n", "<Leader>?", "<Cmd>FzfLua live_grep<CR>")

    require("oil").setup({
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name, _)
                return name == ".."
            end,
        },
    })
    map("n", "-", "<Cmd>Oil<CR>")
    map("n", "_", "<Cmd>Oil .<CR>")

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
    map("n", "<Leader>go", function()
        require("mini.diff").toggle_overlay()
    end)

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
    map({ "n", "x", "o" }, "s", "<Plug>(leap)")
end)
