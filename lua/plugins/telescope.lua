return {
  {
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
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader><space>", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
    },
  },
}
