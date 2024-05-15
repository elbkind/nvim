return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
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
}
