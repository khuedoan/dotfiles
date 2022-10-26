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
    use({ "https://github.com/wbthomason/packer.nvim", commit = "6afb67460283f0e990d35d229fd38fdc04063e0a" }) -- Have packer manage itself
    use({ "https://github.com/nvim-lua/plenary.nvim", commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7" }) -- Useful lua functions used by lots of plugins
    use({ "https://github.com/windwp/nvim-autopairs", commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" }) -- Autopairs, integrates with both cmp and treesitter
    use({ "https://github.com/numToStr/Comment.nvim", commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67" })
    use({ "https://github.com/JoosepAlviste/nvim-ts-context-commentstring", commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08" })
    use({ "https://github.com/kyazdani42/nvim-web-devicons", commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352" })
    use({ "https://github.com/kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" })
    use({ "https://github.com/akinsho/bufferline.nvim", commit = "83bf4dc7bff642e145c8b4547aa596803a8b4dc4" })
    use({ "https://github.com/moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" })
    use({ "https://github.com/nvim-lualine/lualine.nvim", commit = "a52f078026b27694d2290e34efa61a6e4a690621" })
    use({ "https://github.com/akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" })
    use({ "https://github.com/ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" })
    use({ "https://github.com/lewis6991/impatient.nvim", commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6" })
    use({ "https://github.com/lukas-reineke/indent-blankline.nvim", commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6" })
    use({ "https://github.com/goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" })
    use({ "https://github.com/farmergreg/vim-lastplace", commit = "cef9d62165cd26c3c2b881528a5290a84347059e" })
    use({ "https://github.com/windwp/nvim-spectre", commit = "6d877bc1f2262af1053da466e4acd909ad61bc18" })
    use({ "https://github.com/christoomey/vim-tmux-navigator", commit = "afb45a55b452b9238159047ce7c6e161bd4a9907" })
    use({
        "https://github.com/iamcco/markdown-preview.nvim",
        commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96",
        run = function()
            vim.fn["mkdp#util#install"](0)
        end,
    })
    use({ "https://github.com/tpope/vim-eunuch", commit = "cc564695076d89b3d1e06b2693fca788cfbc5910" })
    use({ "https://github.com/tpope/vim-sleuth", commit = "8332f123a63c739c870c96907d987cc3ff719d24" })
    use({ "https://github.com/ggandor/leap.nvim", commit = "5a09c30bf676d1392ff00eb9a41e0a1fc9b60a1b" })

    -- Colorschemes
    use({ "https://github.com/navarasu/onedark.nvim", commit = "6c72a9c5681e0ce00e75848d9426b59ba21539a7" })

    -- cmp plugins
    use({ "https://github.com/hrsh7th/nvim-cmp", commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc" }) -- The completion plugin
    use({ "https://github.com/hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" }) -- buffer completions
    use({ "https://github.com/hrsh7th/cmp-path", commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" }) -- path completions
    use({ "https://github.com/saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" }) -- snippet completions
    use({ "https://github.com/hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" })
    use({ "https://github.com/hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" })

    -- snippets
    use({ "https://github.com/L3MON4D3/LuaSnip", commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84" }) --snippet engine
    use({ "https://github.com/rafamadriz/friendly-snippets", commit = "2be79d8a9b03d4175ba6b3d14b082680de1b31b1" }) -- a bunch of snippets to use

    -- LSP
    use({ "https://github.com/neovim/nvim-lspconfig", commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda" }) -- enable LSP
    use({ "https://github.com/williamboman/mason.nvim", commit = "c2002d7a6b5a72ba02388548cfaf420b864fbc12" })
    use({ "https://github.com/williamboman/mason-lspconfig.nvim", commit = "0051870dd728f4988110a1b2d47f4a4510213e31" })
    use({ "https://github.com/jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" }) -- for formatters and linters

    -- Telescope
    use({ "https://github.com/nvim-telescope/telescope.nvim", commit = "76ea9a898d3307244dce3573392dcf2cc38f340f" })
    use({
        "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
        commit = "65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })

    -- Treesitter
    use({ "https://github.com/nvim-treesitter/nvim-treesitter", commit = "8e763332b7bf7b3a426fd8707b7f5aa85823a5ac" })
    use({ "https://github.com/RRethy/nvim-treesitter-endwise", commit = "0cf4601c330cf724769a2394df555a57d5fd3f34" })

    -- Git
    use({ "https://github.com/lewis6991/gitsigns.nvim", commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f" })
    use({ "https://github.com/APZelos/blamer.nvim", commit = "f4eb22a9013642c411725fdda945ae45f8d93181" })
    use({ "https://github.com/TimUntersberger/neogit", commit = "74c9e29b61780345d3ad9d7a4a4437607caead4a" })
    use({ "https://github.com/sindrets/diffview.nvim", commit = "a1fbcaa7e1e154cfa793ab44da4a6eb0ae15458d" })
    use({ "https://github.com/tpope/vim-fugitive", commit = "dd8107cabf5fe85df94d5eedcae52415e543f208" })

    -- DAP
    use({ "https://github.com/mfussenegger/nvim-dap", commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d" })
    use({ "https://github.com/rcarriga/nvim-dap-ui", commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7" })
    use({ "https://github.com/ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
