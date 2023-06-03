-- Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

local leader_keymaps = {
    b = {
        name = "buffer",
        b = { ":Buffers!<cr>", "Switch buffer" },
        n = { ":bnext<cr>", "Next buffer" },
        p = { ":bprevious<cr>", "Previous buffer" },
        d = {
            function()
                require("mini.bufremove").delete(0, false)
            end,
            "Delete buffer",
        },
        l = { ":b#<cr>", "Switch to last buffer" },
    },
    f = {
        name = "file",
        f = { ":Files!<cr>", "Find file" },
        F = { ":Files! " .. vim.fn.expand("%:p:h") .. "<cr>", "Find file from here" },
        g = { ":GitFiles! --cached --others --exclude-standard<cr>", "Find file in git project" },
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
        p = { ":Telescope projects<cr>", "Switch project" },
        b = { ":NnnPicker<cr>", "Browse project" },
        B = { ":NnnPicker %:p:h<cr>", "Browse project from here" },
    },
    s = {
        name = "search",
        p = { ":Rg!<cr>", "Search project" },
        r = {
            function()
                require("spectre").open_file_search()
            end,
            "Search and replace",
        },
    },
    g = {
        name = "git",
        g = { ":Neogit<cr>", "Git status" },
        s = { ":Neogit<cr>", "Git status" },
        i = { ":Octo issue list<cr>", "GitHub issues" },
        p = { ":Octo pr list<cr>", "GitHub pull requests" },
    },
    m = {
        name = "markdown",
        p = { ":MarkdownPreview<cr>", "Markdown preview" },
    },
    o = {
        name = "open",
        t = { ":edit ~/Documents/notes/todo.md<cr>", "Todo list" },
        p = { ":NeoTreeRevealToggle<cr>", "Project sidebar" },
    },
    [":"] = { ":Legendary<cr>", "Commands" },
}

-- Aliases
leader_keymaps["<leader>"] = leader_keymaps.f.g
leader_keymaps["/"] = leader_keymaps.s.p
leader_keymaps[","] = leader_keymaps.b.b
leader_keymaps["<"] = leader_keymaps.b.B
leader_keymaps["`"] = leader_keymaps.b.l

require("which-key").register(leader_keymaps, { prefix = "<leader>" })

require("which-key").register({
    ["<C-s>"] = { ":update<cr>", "Save" },
    ["<C-q>"] = { ":quit<cr>", "Quit" },
}, {
    mode = "n",
})

require("which-key").register({
    ["<C-c>"] = { '"+y', "Copy to system clipboard" },
}, {
    mode = "v",
})
