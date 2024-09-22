-- Remap space as leader key
vim.g.mapleader = " "

local keymaps = {
    ["<C-s>"] = { ":update<CR>", "Save" },
    ["<C-q>"] = { ":quit<CR>", "Quit" },
    ["<Leader>"] = {
        b = {
            name = "buffer",
            b = { "<Cmd>FzfLua buffers<CR>", "Switch buffer" },
            n = { "<Cmd>bnext<CR>", "Next buffer" },
            p = { "<Cmd>bprevious<CR>", "Previous buffer" },
            d = { function() require("mini.bufremove").delete(0) end, "Delete buffer" },
            l = { "<Cmd>b#<CR>", "Switch to last buffer" },
        },
        f = {
            name = "find",
            f = { "<Cmd>FzfLua files<CR>", "Find file" },
            g = { "<Cmd>FzfLua git_files<CR>", "Find git file" },
        },
        p = {
            name = "project",
            b = { "<Cmd>Oil<CR>", "Browse project from here" },
            B = { "<Cmd>Oil .<CR>", "Browse project" },
            a = {
                function()
                    require("harpoon"):list():add()
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
            l = { "<Cmd>FzfLua blines<CR>", "Search lines in current file" },
            p = { "<Cmd>FzfLua grep_project<CR>", "Search project (fuzzy)" },
            P = { "<Cmd>FzfLua live_grep<CR>", "Search project (regex)" },
            r = {
                function()
                    require("grug-far").grug_far({
                        prefills = {
                            flags = vim.fn.expand("%"),
                        },
                    })
                end,
                "Search and replace in current file",
            },
            R = { function() require("grug-far").grug_far({}) end, "Search and replace in project" },
        },
        g = {
            name = "git",
            s = { "<Cmd>Git<CR>", "Git status" },
            b = { "<Cmd>Git blame<CR>", "Git blame" },
            d = { "<Cmd>Git diff<CR>", "Git diff" },
            l = { "<Cmd>Git log<CR>", "Git log" },
            o = { require("mini.diff").toggle_overlay, "Overlay diff" },
            H = {
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
keymaps["<Leader>"]["<Leader>"] = keymaps["<Leader>"].f.f
keymaps["<Leader>"]["/"] = keymaps["<Leader>"].s.p
keymaps["<Leader>"]["?"] = keymaps["<Leader>"].s.P
keymaps["<Leader>"][","] = keymaps["<Leader>"].b.b
keymaps["<Leader>"]["."] = keymaps["<Leader>"].p.p
keymaps["<Leader>"][">"] = keymaps["<Leader>"].p.a
keymaps["<C-Tab>"] = keymaps["<Leader>"].b.l
keymaps["<C-c>"] = keymaps["<Leader>"].y.c
keymaps["-"] = keymaps["<Leader>"].p.b
keymaps["_"] = keymaps["<Leader>"].p.B

return keymaps
