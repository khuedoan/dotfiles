require("user.plugins")
require("user.options")
require("user.keymaps")
require("user.autocommands")
require("user.cmp")
require("user.treesitter")
require("user.autopairs")
require("user.bufferline")
require("user.indentline")
require("user.tmuxnavigator")
require("user.lsp")
require("user.dap")

if vim.g.neovide == true then
    require("user.neovide")
end
