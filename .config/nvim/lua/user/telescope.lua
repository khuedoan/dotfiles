local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")

telescope.setup({
    defaults = {
        path_display = { "absolute" },
        file_ignore_patterns = { ".git/", "node_modules" },

        mappings = {
            i = {
                ["<Down>"] = actions.cycle_history_next,
                ["<Up>"] = actions.cycle_history_prev,
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
    pickers = {
        find_files = {
            no_ignore = true,
            no_ignore_parent = true,
        },
    },
})

telescope.load_extension("fzf")

local keymap = vim.keymap.set
local opts = { silent = true }

keymap("n", "<leader><leader>", ":Telescope git_files<CR>", opts)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fF", function()
    builtin.find_files({ cwd = utils.buffer_dir() })
end, opts)
keymap("n", "<leader>/", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>pp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>,", ":Telescope buffers<CR>", opts)
