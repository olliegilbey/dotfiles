-- Claude Code Neovim Integration by Coder
-- https://github.com/coder/claudecode.nvim
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>aT", "<cmd>ClaudeCodeToggle<cr>", desc = "Toggle Claude Terminal" },
    { "<leader>aD", "<cmd>ClaudeCodeDiff<cr>", desc = "Show Claude Diff" },
  },
}