vim.g.mapleader = " "
local map = vim.keymap.set

-- Yank
map("x", "<Leader>y", '"+y')
map("n", "<Leader>yF", "<Cmd>let @+ = expand('%:p:~')<CR>")
map("n", "<Leader>yf", "<Cmd>let @+ = expand('%')<CR>")

-- Files
map("n", "<Leader><Leader>", function()
    require("fzf-lua-frecency").frecency({
        cwd = require("oil").get_current_dir(),
        cwd_only = true,
    })
end)
map("n", "<Leader>fg", "<Cmd>FzfLua git_files<CR>")
map("n", "-", "<Cmd>Oil<CR>")
map("n", "_", "<Cmd>Oil .<CR>")

-- Buffers
map("n", "<Leader>,", "<Cmd>FzfLua buffers<CR>")
map("n", "<Leader>bd", function()
    require("mini.bufremove").delete()
end)

-- Git
map("n", "<Leader>gs", "<Cmd>Git<CR>")
map("n", "<Leader>gd", "<Cmd>Git diff<CR>")
map("n", "<Leader>gD", "<Cmd>Git diff --staged<CR>")
map("n", "<Leader>go", require("mini.diff").toggle_overlay)
map("n", "<Leader>gb", "<Cmd>Git blame<CR>")
map("n", "<Leader>gl", "<Cmd>Git log<CR>")
map("n", "<Leader>ghb", "<Cmd>silent !gh browse %<CR>")
map("n", "<Leader>ghr", "<Cmd>silent !gh repo view --web<CR>")

-- Search and replace
map("n", "<Leader>/", "<Cmd>FzfLua grep_project<CR>")
map("n", "<Leader>?", "<Cmd>FzfLua live_grep<CR>")
map("n", "<Leader>sr", function()
    require("grug-far").open({
        prefills = {
            paths = vim.fn.expand("%"),
        },
    })
end)
map("n", "<Leader>sR", function()
    require("grug-far").grug_far({})
end)
