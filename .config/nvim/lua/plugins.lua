-- vim: foldmethod=marker
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    -- {{{ Speed up loading Lua modules
    use({
        "https://github.com/lewis6991/impatient.nvim",
        config = function()
            require("impatient")
        end,
    })
    -- }}}

    -- {{{ Let Packer manage itself
    use({
        "wbthomason/packer.nvim",
        config = function()
            local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePost", {
                command = "source <afile> | PackerCompile",
                group = packer_group,
                pattern = vim.fn.expand("plugins.lua"),
            })
        end,
    })
    --- }}}

    -- {{{ Libraries
    use({ "https://github.com/nvim-lua/plenary.nvim" })
    use({ "https://github.com/kyazdani42/nvim-web-devicons" })
    -- }}}

    -- {{{ UI
    use({
        "https://github.com/navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                transparent = vim.env.TMUX ~= nil,
            })
            require("onedark").load()
        end,
    })

    use({
        "https://github.com/nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                },
            })
        end,
    })

    use({
        "https://github.com/akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup()
        end,
    })

    use({
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                show_first_indent_level = false,
                show_trailing_blankline_indent = false,
                use_treesitter = true,
            })
        end,
    })

    use({
        "https://github.com/j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({
                text = {
                    spinner = "dots",
                },
            })
        end,
    })
    -- }}}

    -- {{{ Search
    use({
        "https://github.com/nvim-telescope/telescope.nvim",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local themes = require("telescope.themes")
            telescope.setup({
                defaults = themes.get_ivy({
                    path_display = { "absolute" },
                    file_ignore_patterns = { ".git/", "node_modules" },

                    mappings = {
                        i = {
                            ["<Down>"] = actions.cycle_history_next,
                            ["<Up>"] = actions.cycle_history_prev,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                }),
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = true,
                        no_ignore_parent = true,
                    },
                    buffers = {
                        sort_mru = true,
                    },
                },
            })
        end,
    })

    use({
        "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    })

    use({
        "https://github.com/windwp/nvim-spectre",
        config = function()
            require("spectre").setup({
                is_insert_mode = true,
                live_update = true,
                highlight = {
                    ui = "String",
                    search = "DiffDelete",
                    replace = "DiffAdd",
                },
            })
        end,
    })

    use({
        "https://github.com/nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").load_extension("ui-select")
        end,
    })
    -- }}}

    -- {{{ File manager
    use({
        "https://github.com/mcchrish/nnn.vim",
        cmd = "NnnPicker",
        config = function()
            require("nnn").setup({
                command = "nnn -o -C",
                set_default_mappings = false,
                replace_netrw = true,
                layout = {
                    down = "25",
                },
                action = {
                    ["<c-t>"] = "tab split",
                    ["<c-s>"] = "split",
                    ["<c-v>"] = "vsplit",
                },
            })
        end,
    })

    use({
        "https://github.com/nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                update_focused_file = {
                    enable = true,
                    update_root = true,
                },
            })
        end,
    })
    -- }}}

    -- {{{ IntelliSense
    use({ "https://github.com/neovim/nvim-lspconfig" })

    use({
        "https://github.com/williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    })

    use({
        "https://github.com/williamboman/mason-lspconfig.nvim",
        config = function()
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
    })
    -- }}}

    -- {{{ Completion
    use({
        "https://github.com/hrsh7th/nvim-cmp",
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
                        vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](vim.api.nvim_replace_termcodes("<Tab>", true, true, true)), "n", true)
                    end)
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "buffer" },
                    { name = "lua_snip" },
                    { name = "nvim_lsp" },
                    { name = "path" },
                }),
                experimental = {
                    ghost_text = false, -- Conflict with Copilot
                },
            })
        end,
    })

    use({ "https://github.com/hrsh7th/cmp-buffer" })
    use({ "https://github.com/hrsh7th/cmp-nvim-lsp" })
    use({ "https://github.com/hrsh7th/cmp-path" })

    use({
        "https://github.com/L3MON4D3/LuaSnip",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    })
    use({ "https://github.com/saadparwaiz1/cmp_luasnip" })
    use({ "https://github.com/rafamadriz/friendly-snippets" })

    use({
        "https://github.com/windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    })

    use({
        "https://github.com/github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.keymap.set("i", "<Plug>(vimrc:copilot-dummy-map)", "copilot#Accept()", { silent = true, expr = true })
        end,
    })
    -- }}}

    -- {{{ Syntax highlighting
    use({
        "https://github.com/nvim-treesitter/nvim-treesitter",
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
    })
    -- }}}

    -- {{{ Formatting
    use({
        "https://github.com/sbdchd/neoformat",
        config = function()
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = {
                    "*.go",
                    "*.lua",
                    "*.py",
                    "*.rs",
                    "*.ts",
                    "*.tsx",
                    "*.yaml",
                    "*.yml",
                },
                command = "silent! Neoformat",
            })

            vim.g.neoformat_try_node_exe = true
        end,
    })
    -- }}}

    -- {{{ Debugging
    -- TODO
    use({ "https://github.com/mfussenegger/nvim-dap" })
    use({ "https://github.com/rcarriga/nvim-dap-ui" })
    use({ "https://github.com/ravenxrz/DAPInstall.nvim" })
    -- }}}

    -- {{{ Markdown
    use({
        "https://github.com/iamcco/markdown-preview.nvim",
        ft = "markdown",
        run = "cd app && yarn install",
    })

    use({
        "https://github.com/jakewvincent/mkdnflow.nvim",
        ft = "markdown",
        config = function()
            require("mkdnflow").setup({
                to_do = {
                    symbols = { " ", "-", "x" },
                },
            })
        end,
    })
    -- }}}

    -- {{{ Git
    use({
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
    })

    use({
        "https://github.com/pwntester/octo.nvim",
        config = function()
            require("octo").setup()
        end,
    })

    use({ "https://github.com/sindrets/diffview.nvim" })

    use({
        "https://github.com/lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
            })
        end,
    })
    -- }}}

    -- {{{ Motions
    use({
        "https://github.com/ggandor/leap.nvim",
        config = function()
            require("leap").set_default_keymaps()
        end,
    })

    use({
        "https://github.com/ggandor/flit.nvim",
        config = function()
            require("flit").setup()
        end,
    })
    -- }}}

    -- {{{ Keymaps
    use({
        "https://github.com/folke/which-key.nvim",
        config = function()
            require("which-key").setup({})

            local leader_keymaps = {
                b = {
                    name = "buffer",
                    b = { "<cmd>Telescope buffers only_cwd=true<cr>", "Switch workspace buffer" },
                    B = { "<cmd>Telescope buffers<cr>", "Switch buffer" },
                    n = { "<cmd>bnext<cr>", "Next buffer" },
                    p = { "<cmd>bprevious<cr>", "Previous buffer" },
                    d = { "<cmd>bdelete<cr>", "Delete buffer" },
                    l = { "<cmd>b#<cr>", "Switch to last buffer" },
                },
                f = {
                    name = "file",
                    f = {
                        function()
                            require("telescope.builtin").find_files()
                        end,
                        "Find file",
                    },
                    F = {
                        function()
                            require("telescope.builtin").find_files({
                                default_text = vim.fn.expand("%:h") .. "/",
                            })
                        end,
                        "Find file from here",
                    },
                    g = { "<cmd>Telescope git_files<cr>", "Find file in git project" },
                    r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
                    y = {
                        function()
                            local path = vim.fn.expand("%:p:~")
                            vim.fn.setreg("+", path)
                            print("Copied path: " .. path)
                        end,
                        "Yank file path",
                    },
                    Y = {
                        function()
                            local path = vim.fn.expand("%")
                            vim.fn.setreg("+", path)
                            print("Copied path: " .. path)
                        end,
                        "Yank file path from project",
                    },
                },
                p = {
                    name = "project",
                    p = { "<cmd>Telescope projects<cr>", "Switch project" },
                    b = { "<cmd>NnnPicker<cr>", "Browse project" },
                    B = { "<cmd>NnnPicker %:p:h<cr>", "Browse project from here" },
                },
                s = {
                    name = "search",
                    p = {
                        function()
                            require("telescope.builtin").grep_string({
                                only_sort_text = true,
                                search = "",
                            })
                        end,
                        "Search project",
                    },
                    r = {
                        function()
                            require("spectre").open_file_search()
                        end,
                        "Search and replace",
                    },
                },
                g = {
                    name = "git",
                    g = { "<cmd>Neogit<cr>", "Git status" },
                    s = { "<cmd>Neogit<cr>", "Git status" },
                    i = { "<cmd>Octo issue list<cr>", "GitHub issues" },
                    p = { "<cmd>Octo pr list<cr>", "GitHub pull requests" },
                },
                m = {
                    name = "markdown",
                    p = { "<cmd>MarkdownPreview<cr>", "Markdown preview" },
                },
                o = {
                    name = "open",
                    t = { "<cmd>edit ~/Documents/notes/todo.md<cr>", "Todo list" },
                    p = { "<cmd>NvimTreeFindFileToggle<cr>", "Project sidebar" },
                },
                [":"] = { "<cmd>Legendary<cr>", "Commands" },
            }

            -- Aliases
            leader_keymaps["<leader>"] = leader_keymaps.f.f
            leader_keymaps["/"] = leader_keymaps.s.p
            leader_keymaps[","] = leader_keymaps.b.b
            leader_keymaps["<"] = leader_keymaps.b.B
            leader_keymaps["`"] = leader_keymaps.b.l
            -- [":"] = { "<cmd>Legendary<cr>"

            require("which-key").register(leader_keymaps, { prefix = "<leader>" })
        end,
    })

    use({
        "https://github.com/mrjones2014/legendary.nvim",
        config = function()
            require("legendary").setup({
                which_key = {
                    auto_register = true,
                },
            })
        end,
    })
    -- }}}

    -- {{{ Miscellaneous
    use({ "https://github.com/farmergreg/vim-lastplace" })
    use({ "https://github.com/tpope/vim-eunuch" })
    use({ "https://github.com/tpope/vim-sleuth" })
    use({ "https://github.com/romainl/vim-cool" })
    use({ "https://github.com/mbbill/undotree" })

    use({
        "https://github.com/numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({})
        end,
    })

    use({
        "https://github.com/christoomey/vim-tmux-navigator",
        config = function()
            vim.g.tmux_navigator_no_mappings = 1
            vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<cr>", { silent = true })
            vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<cr>", { silent = true })
            vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<cr>", { silent = true })
            vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<cr>", { silent = true })
        end,
    })
    -- }}}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
