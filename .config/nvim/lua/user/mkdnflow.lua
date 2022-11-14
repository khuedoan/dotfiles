local status_ok, mkdnflow = pcall(require, "mkdnflow")
if not status_ok then
    return
end

mkdnflow.setup({
    to_do = {
        symbols = { " ", "-", "x" },
    },
    mappings = {
        MkdnEnter = {{'i', 'n', 'v'}, '<CR>'},
    },
})
