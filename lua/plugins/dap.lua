return {
  {
    "microsoft/vscode-js-debug",
    build = "cd  ~/.local/share/nvim/lazy/vscode-js-debug && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } },
}
