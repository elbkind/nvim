vim.o.winborder = "double"
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

vim.o.colorcolumn = "80"

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if not client then
--       return
--     end
--
--     if client.name == "vtsls" then
--       vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--         pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
--         callback = function()
--           vim.lsp.buf.code_action({
--             apply = true,
--             context = {
--               diagnostics = {},
--               only = {
--                 "source.addMissingImports.ts",
--                 "source.organizeImports.biome",
--                 "source.action.useSortedAttributes.biome",
--                 "source.action.useSortedKeys.biome",
--                 "source.fixAll.biome",
--                 -- "quickfix",
--                 -- "refactor",
--                 -- "refactor.extract",
--                 -- "refactor.inline",
--                 -- "refactor.move",
--                 -- "refactor.rewrite",
--                 -- "source",
--                 -- "source.organizeImports",
--                 -- "source.fixAll",
--               },
--             },
--           })
--         end,
--         group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
--       })
--     end
--   end,
-- })
