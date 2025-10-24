-- Git Keymaps - All version control operations
-- Combines LazyGit, Neogit, and Gitsigns

local keymap = vim.keymap.set

-- ============================================================================
-- GIT TUI INTERFACES
-- ============================================================================

keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit (TUI)" })
keymap("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit" })
keymap("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit (Neogit)" })

-- ============================================================================
-- GITSIGNS - HUNK OPERATIONS (<leader>gh prefix)
-- ============================================================================
-- Note: These are set when Gitsigns attaches to a buffer

-- Hunk navigation
keymap("n", "]h", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Next hunk" })

keymap("n", "[h", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true, desc = "Previous hunk" })

-- Hunk operations
keymap({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
keymap({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
keymap("n", "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
keymap("n", "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage hunk" })
keymap("n", "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
keymap("n", "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })

-- Blame operations
keymap("n", "<leader>ghb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })

-- Diff operations
keymap("n", "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })
keymap("n", "<leader>ghD", function()
  require("gitsigns").diffthis("~")
end, { desc = "Diff this ~" })

-- Text object for hunks
keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
