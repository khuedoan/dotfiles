local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
    git = {
        clone_timeout = 300, -- Timeout, in seconds, for git clones
    },
})

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use({ "https://github.com/wbthomason/packer.nvim" }) -- Have packer manage itself
    use({ "https://github.com/nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
    use({ "https://github.com/windwp/nvim-autopairs" }) -- Autopairs, integrates with both cmp and treesitter
    use({ "https://github.com/numToStr/Comment.nvim" })
    use({ "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" })
    use({ "https://github.com/kyazdani42/nvim-web-devicons" })
    use({
        "https://github.com/mcchrish/nnn.vim",
        config = function()
            require("nnn").setup({
                command = "nnn -o -C",
                set_default_mappings = false,
                replace_netrw = true,
                action = {
                    ["<c-t>"] = "tab split",
                    ["<c-s>"] = "split",
                    ["<c-v>"] = "vsplit",
                },
            })

            vim.keymap.set("n", "<LEADER>n", ":NnnExplore<CR>", { silent = true })
            vim.keymap.set("n", "<LEADER>N", ":NnnExplore %:p:h<CR>", { silent = true })
        end,
    })
    use({ "https://github.com/akinsho/bufferline.nvim" })
    use({ "https://github.com/moll/vim-bbye" })
    use({ "https://github.com/nvim-lualine/lualine.nvim" })
    use({ "https://github.com/akinsho/toggleterm.nvim" })
    use({ "https://github.com/ahmedkhalf/project.nvim" })
    use({ "https://github.com/lewis6991/impatient.nvim" })
    use({ "https://github.com/lukas-reineke/indent-blankline.nvim" })
    use({ "https://github.com/farmergreg/vim-lastplace" })
    use({ "https://github.com/windwp/nvim-spectre" })
    use({ "https://github.com/christoomey/vim-tmux-navigator" })
    use({
        "https://github.com/iamcco/markdown-preview.nvim",
        run = "cd app && yarn install",
    })
    use({ "https://github.com/tpope/vim-eunuch" })
    use({ "https://github.com/tpope/vim-sleuth" })
    use({ "https://github.com/ggandor/leap.nvim" })
    use({ "https://github.com/jakewvincent/mkdnflow.nvim" })
    use({
        "https://github.com/mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<LEADER>u", ":UndotreeToggle<CR>", { silent = true })
        end,
    })

    -- Colorschemes
    use({ "https://github.com/navarasu/onedark.nvim" })

    -- cmp plugins
    use({ "https://github.com/hrsh7th/nvim-cmp" }) -- The completion plugin
    use({ "https://github.com/hrsh7th/cmp-buffer" }) -- buffer completions
    use({ "https://github.com/hrsh7th/cmp-path" }) -- path completions
    use({ "https://github.com/saadparwaiz1/cmp_luasnip" }) -- snippet completions
    use({ "https://github.com/hrsh7th/cmp-nvim-lsp" })
    use({ "https://github.com/hrsh7th/cmp-nvim-lua" })

    -- snippets
    use({ "https://github.com/L3MON4D3/LuaSnip" }) --snippet engine
    use({ "https://github.com/rafamadriz/friendly-snippets" }) -- a bunch of snippets to use

    -- LSP
    use({ "https://github.com/neovim/nvim-lspconfig" }) -- enable LSP
    use({ "https://github.com/williamboman/mason.nvim" })
    use({ "https://github.com/williamboman/mason-lspconfig.nvim" })
    use({ "https://github.com/jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters

    -- Telescope
    use({ "https://github.com/nvim-telescope/telescope.nvim" })
    use({
        "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
    })

    -- Treesitter
    use({ "https://github.com/nvim-treesitter/nvim-treesitter" })
    use({ "https://github.com/RRethy/nvim-treesitter-endwise" })

    -- Git
    use({ "https://github.com/lewis6991/gitsigns.nvim" })
    use({ "https://github.com/APZelos/blamer.nvim" })
    use({
        "https://github.com/TimUntersberger/neogit",
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
    use({ "https://github.com/sindrets/diffview.nvim" })
    use({ "https://github.com/tpope/vim-fugitive" })

    -- DAP
    use({ "https://github.com/mfussenegger/nvim-dap" })
    use({ "https://github.com/rcarriga/nvim-dap-ui" })
    use({ "https://github.com/ravenxrz/DAPInstall.nvim" })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
