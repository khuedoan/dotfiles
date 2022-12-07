require("user.plugins")
require("user.impatient")
require("user.options")
require("user.keymaps")
require("user.autocommands")
require("user.colorscheme")
require("user.cmp")
require("user.telescope")
require("user.spectre")
require("user.gitsigns")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.bufferline")
require("user.lualine")
require("user.toggleterm")
require("user.project")
require("user.indentline")
require("user.tmuxnavigator")
require("user.leap")
require("user.mkdnflow")
require("user.lsp")
require("user.dap")

if vim.g.neovide == true then
    require("user.neovide")
end
