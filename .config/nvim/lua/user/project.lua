local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
    return
end
project.setup({
    detection_methods = { "pattern" },
    patterns = { ".git" },
})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
    return
end

telescope.load_extension("projects")
