-- AI/Claude Code Keymaps
-- <leader>a prefix for AI-assisted development

local keymap = vim.keymap.set

-- ============================================================================
-- CLAUDE CODE INTEGRATION
-- ============================================================================

keymap("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
keymap("n", "<leader>aT", "<cmd>ClaudeCodeToggle<cr>", { desc = "Toggle Claude terminal" })
keymap("n", "<leader>aD", "<cmd>ClaudeCodeDiff<cr>", { desc = "Show Claude diff" })

-- Future AI integrations can be added here with <leader>a prefix
