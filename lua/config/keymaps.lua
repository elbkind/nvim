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
vim.keymap.set("n", "<leader><space>", function()
  Snacks.picker("smart", { root = false })
end, { desc = "Smart Find Files (cwd)" })
vim.keymap.set("n", "<leader>/", function()
  Snacks.picker("live_grep", { root = false })
end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>fz", function()
  Snacks.picker.files({ cwd = "~/.config/wezterm" })
end, { desc = "Wezterm files" })
vim.keymap.set("n", "<leader>fx", function()
  Snacks.picker.files({ cwd = "~/.config/tmux" })
end, { desc = "tmux files" })
vim.keymap.set("n", "<leader>fl", function()
  Snacks.explorer.reveal()
end, { desc = "Reval in finder" })

vim.keymap.set("n", "<leader>pc", function()
  local filepath = vim.fn.expand("%")
  vim.fn.setreg("+", filepath) -- write to clippoard
end, { noremap = true, silent = true, desc = "Copy current buffer path to clibboard" })
