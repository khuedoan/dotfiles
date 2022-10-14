local status_ok, spectre = pcall(require, "spectre")
if not status_ok then
    return
end

spectre.setup({
    live_update = true,
    highlight = {
        ui = "String",
        search = "DiffDelete",
        replace = "DiffAdd",
    },
})

vim.keymap.set("n", "<leader>R", function()
    spectre.open()
end, { silent = true })
