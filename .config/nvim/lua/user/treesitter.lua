local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
    return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
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
})
