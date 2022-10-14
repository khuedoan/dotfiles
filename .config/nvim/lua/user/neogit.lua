local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
    return
end

neogit.setup({
    disable_commit_confirmation = true,
    disable_context_highlighting = true,
    integrations = {
        diffview = true,
    },
})

vim.keymap.set("n", "<leader>gs", ":Neogit kind=split<cr>", { silent = true })
