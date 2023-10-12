-- Remap space as leader key
vim.g.mapleader = " "

local keymaps = {
    ["<Leader>"] = {
        b = {
            name = "buffer",
            b = { "<Cmd>Buffers!<cr>", "Switch buffer" },
            n = { "<Cmd>bnext<cr>", "Next buffer" },
            p = { "<Cmd>bprevious<cr>", "Previous buffer" },
            d = {
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                "Delete buffer",
            },
            l = { "<Cmd>b#<cr>", "Switch to last buffer" },
        },
        f = {
            name = "file",
            f = { "<Cmd>Files!<cr>", "Find file" },
            g = { "<Cmd>GitFiles!<cr>", "Find file in git project" },
            s = { "<Cmd>update<cr>", "Save" },
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
            b = { "<Cmd>Oil<cr>", "Browse project from here" },
            B = { "<Cmd>Oil .<cr>", "Browse project" },
        },
        q = {
            name = "quit/session",
            q = { "<Cmd>quit<cr>", "Quit" },
        },
        s = {
            name = "search",
            l = { "<Cmd>Lines!<CR>", "Search lines in current file", },
            p = { "<Cmd>Rg!<cr>", "Search project" },
            P = { "<Cmd>RG!<CR>", "Search project (strict)", },
        },
        g = {
            name = "git",
            g = { "<Cmd>Neogit<cr>", "Git status" },
            s = { "<Cmd>Neogit<cr>", "Git status" },
            l = { "<Cmd>DiffviewFileHistory<cr>", "Git log", mode = { "n", "v" } },
        },
        m = {
            name = "markdown",
            p = { "<Cmd>MarkdownPreview<cr>", "Markdown preview" },
        },
        o = {
            name = "open",
            t = { "<Cmd>edit ~/Documents/notes/todo.md<cr>", "Todo list" },
        },
        [":"] = { "<Cmd>Legendary<cr>", "Commands" },
    },
    ["<C-c>"] = { '"+y', "Copy to system clipboard", mode = "v" },
}

-- Aliases
keymaps["<Leader>"]["<Leader>"] = keymaps["<Leader>"].f.g
keymaps["<Leader>"]["/"] = keymaps["<Leader>"].s.p
keymaps["<Leader>"][","] = keymaps["<Leader>"].b.b
keymaps["<Leader>"]["<"] = keymaps["<Leader>"].b.B
keymaps["<Leader>"]["`"] = keymaps["<Leader>"].b.l
keymaps["<C-s>"] = keymaps["<Leader>"].f.s
keymaps["<C-q>"] = keymaps["<Leader>"].q.q
keymaps["<C-Tab>"] = keymaps["<Leader>"].b.n
keymaps["<C-S-Tab>"] = keymaps["<Leader>"].b.p
keymaps["-"] = keymaps["<Leader>"].p.b
keymaps["_"] = keymaps["<Leader>"].p.B

return keymaps
