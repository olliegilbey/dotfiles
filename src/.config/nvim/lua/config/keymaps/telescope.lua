-- Telescope Keymaps - Find/Search Operations
-- <leader>f for find, <leader>s for search

local keymap = vim.keymap.set

-- ============================================================================
-- COMMAND PALETTE (most used - double leader for speed)
-- ============================================================================

keymap("n", "<leader><leader>", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- ============================================================================
-- FIND/FILE (<leader>f group)
-- ============================================================================

keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fF", function()
  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--no-ignore", "--exclude", ".git" }
  })
end, { desc = "Find ALL files (incl gitignored)" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep (search text)" })
keymap("n", "<leader>fG", function()
  require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--no-ignore", "--glob=!.git/" } })
end, { desc = "Grep ALL files (incl gitignored)" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help tags" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
keymap("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
keymap("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Git status files" })
keymap("n", "<leader>fm", "<cmd>Telescope marks<cr>", { desc = "Find marks" })
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Find diagnostics" })

-- ============================================================================
-- SEARCH (<leader>s group + fuzzy in buffer)
-- ============================================================================

keymap("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in buffer" })
keymap("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep in project" })
keymap("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search buffer" })
keymap("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Search help" })

-- ============================================================================
-- ADDITIONAL PICKERS
-- ============================================================================

-- LSP-related pickers (defined here for consistency)
keymap("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
keymap("n", "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
