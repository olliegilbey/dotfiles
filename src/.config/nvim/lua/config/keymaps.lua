-- Keymap Orchestrator - Loads all modular keymaps
-- Philosophy: Frequency-optimized, semantically grouped, conflict-free
-- Documentation: ~/.config/nvim/docs/KEYMAPS.md

-- Remove conflicting LazyVim defaults before loading our keymaps (safely)
pcall(vim.keymap.del, "n", "<leader>e") -- Repurpose for file explorer (was diagnostic float)

-- Load modular keymap modules
require("config.keymaps.core")       -- Enhanced vim defaults
require("config.keymaps.navigation") -- Windows, buffers, Flash
require("config.keymaps.lsp")        -- LSP operations
require("config.keymaps.telescope")  -- Find/search
require("config.keymaps.git")        -- Git operations
require("config.keymaps.languages")  -- Context-aware language tools
require("config.keymaps.todo")       -- Todo.txt
require("config.keymaps.terminal")   -- Terminal & UI toggles
require("config.keymaps.ai")         -- Claude Code
