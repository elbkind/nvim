return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      defaults = {
        formatter = "path.filename_first",
        --       path_shorten = true,
      },
    })
  end,
}
