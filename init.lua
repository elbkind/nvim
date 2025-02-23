-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
--require("newpaper").setup({})
require("github-theme").setup({})
-- vim.cmd("colorscheme github_dark_colorblind")
vim.cmd("colorscheme github_light_high_contrast")

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

-- require("codecompanion").setup({
--   strategies = {
--     chat = {
--       adapter = "ollama",
--     },
--     inline = {
--       adapter = "ollama",
--     },
--   },
-- })
--
-- require("codecompanion").setup({
--   adapters = {
--     llama3 = function()
--       return require("codecompanion.adapters").extend("ollama", {
--         name = "llama3", -- Give this adapter a different name to differentiate it from the default ollama adapter
--
--         schema = {
--           model = {
--             default = "llama3:latest",
--           },
--           num_ctx = {
--             default = 16384,
--           },
--           num_predict = {
--             default = -1,
--           },
--         },
--       })
--     end,
--   },
-- })
--
-- require("codecompanion").setup({
--   strategies = {
--     -- Change the default chat adapter
--     inline = {
--       adapter = "ollama",
--       keymaps = {
--         accept_change = {
--           modes = { n = "ga" },
--           description = "Accept the suggested change",
--         },
--         reject_change = {
--           modes = { n = "gr" },
--           description = "Reject the suggested change",
--         },
--       },
--     },
--     chat = {
--       adapter = "ollama",
--     },
--   },
-- })
-- --   adapters = {
-- --     ollama = function()
-- --       return require("codecompanion.adapters").extend("ollama", {
-- --         env = {
-- --           url = "http://darkstar:11434",
-- --           -- api_key = "OLLAMA_API_KEY",
-- --         },
-- --         headers = {
-- --           ["Content-Type"] = "application/json",
-- --           -- ["Authorization"] = "Bearer ${api_key}",
-- --   },
-- --   parameters = {
-- --     sync = true,
-- --   },
-- -- })
-- --     end,
-- --   },
-- -- })
