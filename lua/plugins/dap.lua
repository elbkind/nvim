return {
  {
    "microsoft/vscode-js-debug",
    build = "cd  ~/.local/share/nvim/lazy/vscode-js-debug && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    requires = { "mfussenegger/nvim-dap" },

    config = function()
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = {
          "chrome",
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
          "node",
          "chrome",
        }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end
    end,
  },
}
