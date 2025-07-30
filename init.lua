-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--require("newpaper").setup({})
require("github-theme").setup({})
vim.cmd("colorscheme github_dark_colorblind")
-- vim.cmd("colorscheme github_light_high_contrast")

-- make git dir the root dir, fixes references with
local lspconfig = require("lspconfig")
local root_dir = lspconfig.util.root_pattern(".git")
-- local servers = { "vtsls" }
--
-- for _, lsp in pairs(servers) do
--   lspconfig[lsp].setup({
--     root_dir = root_dir,
--   })
-- end

local inlayHints = {
  parameterNames = { enabled = "all" },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

lspconfig.vtsls.setup({
  root_dir = root_dir,
  settings = {
    javascript = { inlayHints = inlayHints },
    typescript = { inlayHints = inlayHints },
  },
})

vim.o.winborder = "rounded"
