-- shameless copy from https://github.com/Shock9616/nvim-config/blob/main/lua/shock/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        --        theme = "auto",
        --        component_separators = "",
        section_separators = { left = "", right = "" },
      },
    })
  end,
}
