-- Core Keymaps - Enhanced Vim Defaults
-- These preserve vim fundamentals while adding quality-of-life improvements

local keymap = vim.keymap.set

-- Better up/down for wrapped lines
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (handles wrapping)" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (handles wrapping)" })

-- Better indenting (keeps visual selection)
keymap("v", "<", "<gv", { desc = "Indent left (keep selection)" })
keymap("v", ">", ">gv", { desc = "Indent right (keep selection)" })

-- Better paste (don't yank replaced text)
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Clear search highlighting
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file (universal across all modes)
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Add undo break-points in insert mode (smarter undo)
keymap("i", ",", ",<c-g>u", { desc = "Undo break-point" })
keymap("i", ".", ".<c-g>u", { desc = "Undo break-point" })
keymap("i", ";", ";<c-g>u", { desc = "Undo break-point" })

-- Terminal mode navigation
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

-- Better command line history
keymap("c", "<C-p>", "<Up>", { desc = "Previous command" })
keymap("c", "<C-n>", "<Down>", { desc = "Next command" })

-- Quick line operations
keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen after jumps
keymap("n", "n", "nzz", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzz", { desc = "Previous search result (centered)" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Quickfix navigation
keymap("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
keymap("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

-- Location list navigation
keymap("n", "[l", "<cmd>lprev<cr>", { desc = "Previous location" })
keymap("n", "]l", "<cmd>lnext<cr>", { desc = "Next location" })

-- Quit keymaps (standard vim convention)
keymap("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit current buffer" })
keymap("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all" })
keymap("n", "<leader>qw", "<cmd>wq<cr>", { desc = "Save and quit current" })
keymap("n", "<leader>qW", "<cmd>wqa<cr>", { desc = "Save all and quit all" })
