return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        selection_caret = "󱞩 ",
        prompt_prefix = " 🔍 ",
        path_display = {
          "filename_first",
        },
      },
      pickers = {
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        grep_string = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    })
  end,
  keys = {
    { "<leader>/", LazyVim.telescope("live_grep", { cwd = false }), desc = "Grep (CWD Dir)" },
    { "<leader><space>", LazyVim.telescope("files", { cwd = false }), desc = "Find Files (CWD Dir)" },
  },
}
