local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    always_visible = true,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = "", modified = "", removed = "" }, -- changes diff symbols
    cond = hide_in_width,
}

local filetype = {
    "filetype",
    icons_enabled = false,
}

local location = {
    "location",
    padding = 0,
}

local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
    options = {
        globalstatus = true,
        theme = "auto",
        disabled_filetypes = { "alpha", "dashboard" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { diagnostics },
        lualine_x = { diff, spaces, "encoding", filetype },
        lualine_y = { location },
        lualine_z = { "progress" },
    },
})
