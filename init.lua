-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--require("newpaper").setup({})
require("github-theme").setup({})
vim.cmd("colorscheme github_dark_colorblind")

vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

-- make git dir the root dir, fixes references with
-- fzf references
local nvim_lsp = require("lspconfig")
local root_dir = nvim_lsp.util.root_pattern(".git")
local servers = { "vtsls" }
local lspconfig = require("lspconfig")

for _, lsp in pairs(servers) do
  lspconfig[lsp].setup({
    root_dir = root_dir,
  })
end
