return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
        },
      },
      hidden = true,
      layout = {
        layout = {
          backdrop = false,
          row = 1,
          width = 0.9,
          min_width = 80,
          height = 0.9,
          border = "none",
          box = "vertical",
          { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", border = "hpad" },
          { win = "preview", title = "{preview}", border = "rounded" },
          -- backdrop = false,
          -- width = 0.9,
          -- min_width = 80,
          -- height = 0.8,
          -- min_height = 30,
          -- box = "vertical",
          -- border = "rounded",
          -- title = "{title} {live} {flags}",
          -- title_pos = "center",
          -- { win = "input", height = 1, border = "bottom" },
          -- { win = "list", border = "none" },
          -- { win = "preview", title = "{preview}", height = 0.4, border = "top" },
        },
      },
    },
    bigfile = { enabled = true },
    terminal = { enabled = true },
    indent = {
      enabled = false,
      indent = {
        hl = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowViolet",
          "RainbowBlue",
          "RainbowGreen",
          "RainbowOrange",
          "RainbowCyan",
          "RainbowWhite",
        },
      },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "keys", gap = 1, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2 },
        { icon = " ", title = "Projects", section = "projects", indent = 2 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "P",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },
  },
  keys = {
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
