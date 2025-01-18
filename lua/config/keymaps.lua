-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.api.nvim_set_keymap

local default_opts = { noremap = true, silent = true }

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", default_opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", default_opts)

local dap = require("dap")

-- Set keymaps to control the debugger
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
-- vim.keymap.set("n", "<leader>b", p").toggle_breakpoint)
-- vim.keymap.set("n", "<leader>B", function()
--  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
-- end)

vim.keymap.set("n", "<leader>fz", function()
  Snacks.picker.files({ cwd = "~/.config/wezterm" })
end, { desc = "Wezterm files" })
vim.keymap.set("n", "<leader>/", function()
  require("fzf-lua").live_grep({ cmd = "rg --line-number --column --color=always --hidden" })
end)
