-- Remap space as leader key
vim.g.mapleader = " "

return {
    -- Session
    { "<C-q>", ":quit<CR>", desc = "Quit" },
    { "<C-s>", ":update<CR>", desc = "Save" },

    -- Files
    {
        "<Leader><Leader>",
        function()
            require("fzf-lua").files({
                cwd = require("oil").get_current_dir(),
            })
        end,
        desc = "Find file",
    },
    { "<Leader>fg", "<Cmd>FzfLua git_files<CR>", desc = "Find git files" },
    { "-", "<Cmd>Oil<CR>", desc = "Browse project from here" },
    { "_", "<Cmd>Oil .<CR>", desc = "Browse project" },
    {
        "<Leader>.",
        function()
            require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Browse pinned files in project",
    },
    {
        "<Leader>>",
        function()
            require("harpoon"):list():add()
        end,
        desc = "Add current file to pinned list",
    },

    -- Buffer
    { "<Leader>,", "<Cmd>FzfLua buffers<CR>", desc = "Switch buffer" },
    {
        "<Leader>bd",
        function()
            require("mini.bufremove").delete(0)
        end,
        desc = "Delete buffer",
    },
    { "<C-Tab>", "<Cmd>bnext<CR>", desc = "Next buffer" },
    { "<C-S-Tab>", "<Cmd>bprevious<CR>", desc = "Previous buffer" },

    -- Git
    { "<Leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
    { "<Leader>gb", "<Cmd>Git blame<CR>", desc = "Git blame" },
    { "<Leader>gl", "<Cmd>Git log<CR>", desc = "Git log" },
    { "<Leader>ghb", "<Cmd>silent !gh browse %<CR>", desc = "GitHub browse" },
    { "<Leader>ghr", "<Cmd>silent !gh repo view --web<CR>", desc = "GitHub repo" },
    {
        "<Leader>gd",
        function()
            require("mini.diff").toggle_overlay()
        end,
        desc = "Git diff overlay",
    },

    -- Search and replace
    { "<Leader>/", "<Cmd>FzfLua grep_project<CR>", desc = "Search project (fuzzy)" },
    { "<Leader>?", "<Cmd>FzfLua live_grep<CR>", desc = "Search project (regex)" },
    {
        "<Leader>sr",
        function()
            require("grug-far").open({
                prefills = {
                    paths = vim.fn.expand("%"),
                },
            })
        end,
        desc = "Search and replace in current file",
    },
    {
        "<Leader>sR",
        function()
            require("grug-far").grug_far({})
        end,
        desc = "Search and replace in project",
    },

    -- Yank
    { "<C-c>", '"+y', mode = { "n", "v" } , desc = "Yank to clipboard"},
    { "<Leader>yF", "<Cmd>let @+ = expand('%:p:~')<CR>", desc = "Yank absolute file path to clipboard" },
    { "<Leader>yf", "<Cmd>let @+ = expand('%')<CR>", desc = "Yank relative file path to clipboard" },

    -- LSP
    { "K", vim.lsp.buf.hover, desc = "Toggle hover" },
    { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
    { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
    { "go", vim.lsp.buf.type_definition, desc = "Go to type definition" },
    { "gR", vim.lsp.buf.references, desc = "Go to references" },
    { "gs", vim.lsp.buf.signature_help, desc = "Show signature" },
    { "gr", vim.lsp.buf.rename, desc = "Rename symbol" },
    { "<Leader>=", mode = {"n", "x" }, vim.lsp.buf.format, desc = "Format buffer" },
    { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
}
