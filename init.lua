-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--require("newpaper").setup({})
require("github-theme").setup({})
vim.cmd("colorscheme github_dark_colorblind")
