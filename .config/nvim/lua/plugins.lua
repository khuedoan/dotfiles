-- Automatically install packer
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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | PackerCompile",
    group = packer_group,
    pattern = vim.fn.expand("plugins.lua"),
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
    },
})

-- Install your plugins here
return packer.startup(function(use)
    use({ "https://github.com/wbthomason/packer.nvim" }) -- Have packer manage itself
    use({
        "https://github.com/lewis6991/impatient.nvim",
        config = function()
            require("impatient")
        end
    })
    use({ "https://github.com/nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
    use({
        "https://github.com/numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({})
        end,
    })
    use({ "https://github.com/kyazdani42/nvim-web-devicons" })
    use({
        "https://github.com/kyazdani42/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                },
            })
        end,
    })
    use({
        "https://github.com/mcchrish/nnn.vim",
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
        "https://github.com/akinsho/bufferline.nvim",
        config = function()
            require("bufferline").setup({
                options = {
                    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                    separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
                },
            })
        end
    })
    use({ "https://github.com/moll/vim-bbye" })
    use({
        "https://github.com/nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = true,
                    theme = "auto",
                },
            })
        end,
    })
    use({
        "https://github.com/akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                size = 25,
                open_mapping = [[<C-\>]],
                shade_terminals = false,
                persist_size = true,
                direction = "horizontal",
            })

            vim.api.nvim_create_autocmd({ "TermOpen" }, {
                pattern = "term://*",
                callback = function()
                    vim.opt_local.signcolumn = "no"
                    vim.keymap.set("t", "<M-h>", "<CMD>wincmd h<CR>", { buffer = true })
                    vim.keymap.set("t", "<M-j>", "<CMD>wincmd j<CR>", { buffer = true })
                    vim.keymap.set("t", "<M-k>", "<CMD>wincmd k<CR>", { buffer = true })
                    vim.keymap.set("t", "<M-l>", "<CMD>wincmd l<CR>", { buffer = true })
                end,
            })
        end,
    })
    use({
        "https://github.com/ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup({
                detection_methods = { "pattern" },
                patterns = {
                    ".git",
                    "shell.nix",
                },
                silent_chdir = false,
            })

            require("telescope").load_extension("projects")
        end,
    })
    use({
        "https://github.com/lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                char = "▏",
                show_trailing_blankline_indent = false,
                show_first_indent_level = false,
                use_treesitter = true,
                show_current_context = true,
                buftype_exclude = { "terminal", "nofile" },
                filetype_exclude = {
                    "help",
                    "packer",
                },
            })
        end
    })
    use({ "https://github.com/farmergreg/vim-lastplace" })
    use({
        "https://github.com/windwp/nvim-spectre",
        config = function()
            require("spectre").setup({
                live_update = true,
                highlight = {
                    ui = "String",
                    search = "DiffDelete",
                    replace = "DiffAdd",
                },
            })

            vim.keymap.set("n", "<leader>R", function()
                require("spectre").open()
            end, { silent = true })
        end
    })
    use({
        "https://github.com/christoomey/vim-tmux-navigator",
        config = function()
            vim.g.tmux_navigator_no_mappings = 1
            vim.keymap.set("n", "<M-h>", ":TmuxNavigateLeft<cr>", { silent = true })
            vim.keymap.set("n", "<M-j>", ":TmuxNavigateDown<cr>", { silent = true })
            vim.keymap.set("n", "<M-k>", ":TmuxNavigateUp<cr>", { silent = true })
            vim.keymap.set("n", "<M-l>", ":TmuxNavigateRight<cr>", { silent = true })
        end
    })
    use({
        "https://github.com/iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
    })
    use({ "https://github.com/tpope/vim-eunuch" })
    use({ "https://github.com/tpope/vim-sleuth" })
    use({
        "https://github.com/ggandor/leap.nvim",
        config = function()
            require("leap").set_default_keymaps()
        end
    })
    use({
        "https://github.com/jakewvincent/mkdnflow.nvim",
        config = function()
            require("mkdnflow").setup({
                to_do = {
                    symbols = { " ", "-", "x" },
                },
                mappings = {
                    MkdnEnter = { { "i", "n", "v" }, "<CR>" },
                },
            })
        end
    })
    use({
        "https://github.com/mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<LEADER>u", ":UndotreeToggle<CR>", { silent = true })
        end,
    })
    use({ "https://github.com/stevearc/dressing.nvim" })
    use({ "https://github.com/romainl/vim-cool" })

    -- Colorschemes
    use({
        "https://github.com/navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                transparent = vim.env.TMUX ~= nil,
            })
            require("onedark").load()
        end,
    })

    -- Completion
    use({
        "https://github.com/hrsh7th/nvim-cmp",
        requires = {
            "https://github.com/hrsh7th/cmp-buffer",
            "https://github.com/hrsh7th/cmp-nvim-lsp",
            "https://github.com/hrsh7th/cmp-nvim-lua",
            "https://github.com/hrsh7th/cmp-path",
            "https://github.com/hrsh7th/cmp-copilot",
            "https://github.com/saadparwaiz1/cmp_luasnip",
            "https://github.com/L3MON4D3/LuaSnip",
            "https://github.com/rafamadriz/friendly-snippets",
            "https://github.com/windwp/nvim-autopairs",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local autopairs = require("nvim-autopairs")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    -- Accept currently selected item. If none selected, `select` first item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif check_backspace() then
                            fallback()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                }),
                sources = {
                    { name = "buffer" },
                    { name = "copilot" },
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                experimental = {
                    ghost_text = false,
                },
            })

            autopairs.setup({
                check_ts = true, -- treesitter integration
                disable_filetype = { "TelescopePrompt" },
                ts_config = {
                    lua = { "string", "source" },
                    javascript = { "string", "template_string" },
                    java = false,
                },

                fast_wrap = {
                    map = "<M-e>",
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                    offset = 0, -- Offset from pattern match
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "PmenuSel",
                    highlight_grey = "LineNr",
                },
            })

            cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({}))
        end
    })

    -- LSP
    use({
        "https://github.com/neovim/nvim-lspconfig",
        requires = {
            "https://github.com/williamboman/mason.nvim",
            "https://github.com/williamboman/mason-lspconfig.nvim",
            "https://github.com/jose-elias-alvarez/null-ls.nvim",
        },
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
    use({
        "https://github.com/github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true
        end
    })

    -- Telescope
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

    -- Treesitter
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
                    "python",
                    "rego",
                    "rust",
                    "typescript",
                    "yaml",
                },

                highlight = {
                    enable = true,
                },
                autopairs = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },

                context_commentstring = {
                    enable = true,
                    enable_autocmd = false,
                },

                endwise = {
                    enable = true,
                },
            })
        end
    })
    use({ "https://github.com/RRethy/nvim-treesitter-endwise" })

    -- Git
    use({
        "https://github.com/lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
        end
    })
    use({ "https://github.com/APZelos/blamer.nvim" })
    use({
        "https://github.com/TimUntersberger/neogit",
        config = function()
            require("neogit").setup({
                disable_commit_confirmation = true,
                disable_context_highlighting = false,
                kind = "split",
                integrations = {
                    diffview = true,
                },
            })
        end,
    })
    use({ "https://github.com/sindrets/diffview.nvim" })
    use({ "https://github.com/tpope/vim-fugitive" })

    -- DAP
    use({ "https://github.com/mfussenegger/nvim-dap" })
    use({
        "https://github.com/rcarriga/nvim-dap-ui",
        requires = {
            "https://github.com/mfussenegger/nvim-dap",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup({})
            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    })
    use({
        "https://github.com/ravenxrz/DAPInstall.nvim",
        config = function()
            local dap_install = require("dap-install")
            dap_install.setup({})
            dap_install.config("python", {})
        end
    })

    -- Keymaps
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
                },
                g = {
                    name = "git",
                    g = { "<cmd>Neogit<cr>", "Git status" },
                    s = { "<cmd>Neogit<cr>", "Git status" },
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
                [":"] = { "<cmd>Telescope commands<cr>", "Commands" },
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
    -- TODO
    -- use({
    --     "https://github.com/mrjones2014/legendary.nvim",
    --     config = function()
    --         require("legendary").setup({
    --             which_key = {
    --                 auto_register = true
    --             }
    --         })
    --     end,
    -- })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
