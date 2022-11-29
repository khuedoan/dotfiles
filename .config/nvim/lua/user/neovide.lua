vim.opt.guifont = "FiraCode Nerd Font Mono:h9" -- the font used in graphical neovim applications

-- TODO https://github.com/neovide/neovide/pull/1652
-- vim.g.neovide_refresh_rate = 180
-- vim.g.neovide_profiler = true

vim.keymap.set("i", "<C-S-v>", '<C-r>+', { silent = true })
vim.keymap.set(
    "n", "<C-=>",
    function ()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    end,
    { silent = true }
)
vim.keymap.set(
    "n", "<C-->",
    function ()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
    end,
    { silent = true }
)
vim.keymap.set(
    "n", "<C-0>",
    function ()
        vim.g.neovide_scale_factor = 1
    end,
    { silent = true }
)
