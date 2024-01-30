-- Remap space as leader key
vim.g.mapleader = " "

local keymaps = {
    ["<Leader>"] = {
        b = {
            name = "buffer",
            b = { "<Cmd>Buffers!<CR>", "Switch buffer" },
            n = { "<Cmd>bnext<CR>", "Next buffer" },
            p = { "<Cmd>bprevious<CR>", "Previous buffer" },
            d = { function() require("mini.bufremove").delete(0) end, "Delete buffer" },
            l = { "<Cmd>b#<CR>", "Switch to last buffer" },
        },
        f = {
            name = "find",
            f = { "<Cmd>Files!<CR>", "Find file" },
            g = { "<Cmd>GitFiles!<CR>", "Find git file" },
            s = { "<Cmd>update<CR>", "Save" },
        },
        p = {
            name = "project",
            b = { "<Cmd>Oil<CR>", "Browse project from here" },
            B = { "<Cmd>Oil .<CR>", "Browse project" },
            a = {
                function()
                    require("harpoon"):list():append()
                end,
                "Add current file to pinned list",
            },
            p = {
                function()
                    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
                end,
                "Browse pinned files in project",
            },
        },
        s = {
            name = "search",
            l = { "<Cmd>Lines!<CR>", "Search lines in current file" },
            p = { "<Cmd>Rg!<CR>", "Search project (fuzzy)" },
            P = { "<Cmd>RG!<CR>", "Search project (exact)" },
        },
        g = {
            name = "git",
            s = { "<Cmd>Neogit<CR>", "Git status" },
            h = {
                name = "GitHub",
                b = { "<Cmd>silent !gh browse %<CR>", "GitHub browse current file" },
                r = {
                    name = "repo",
                    v = { "<Cmd>silent !gh repo view --web<CR>", "GitHub repo view" },
                },
            },
        },
        o = {
            name = "open",
            t = { "<Cmd>edit ~/Documents/notes/todo.md<CR>", "Todo list" },
            c = { "<Cmd>Oil ~/.config/nvim/<CR>", "Neovim config" },
        },
        y = {
            name = "yank",
            c = { '"+y', "Yank to system clipboard", mode = { "n", "v" } },
            f = { "<Cmd>let @+ = expand('%')<CR>", "Yank relative file path" },
            F = { "<Cmd>let @+ = expand('%:p:~')<CR>", "Yank relative file path" },
        },
    },
}

-- Aliases
keymaps["<Leader>"]["<Leader>"] = keymaps["<Leader>"].f.g
keymaps["<Leader>"]["/"] = keymaps["<Leader>"].s.p
keymaps["<Leader>"]["?"] = keymaps["<Leader>"].s.P
keymaps["<Leader>"][","] = keymaps["<Leader>"].b.b
keymaps["<C-c>"] = keymaps["<Leader>"].y.c
keymaps["-"] = keymaps["<Leader>"].p.b
keymaps["_"] = keymaps["<Leader>"].p.B

return keymaps
