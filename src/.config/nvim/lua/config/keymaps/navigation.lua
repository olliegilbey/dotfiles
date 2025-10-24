-- Navigation Keymaps - Windows, Buffers, Flash
-- Optimized for home row speed

local keymap = vim.keymap.set

-- ============================================================================
-- WINDOW NAVIGATION & MANAGEMENT
-- ============================================================================

-- Navigate between windows (fast vim-style)
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Terminal window navigation
keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Resize windows with arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Window management (<leader>w group)
keymap("n", "<leader>ww", "<C-w>w", { desc = "Go to other window" })
keymap("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split horizontal" })
keymap("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
keymap("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
keymap("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })

-- ============================================================================
-- BUFFER NAVIGATION
-- ============================================================================

-- Fast buffer switching (Shift + h/l)
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Alternative buffer navigation
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- ============================================================================
-- LINE MOVEMENT (Alt + j/k for multi-line moves)
-- ============================================================================

-- Move lines in normal mode
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Move lines in insert mode
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

-- Move lines in visual mode
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- ============================================================================
-- FLASH.NVIM - HOME ROW POWER NAVIGATION
-- ============================================================================
-- Note: s/S override vim substitute (worth it - use cl/cc instead)

keymap({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash Jump (2-char search)" })

keymap({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter (structural)" })

-- Remote Flash (operator-pending only)
keymap("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })

-- Treesitter Search
keymap({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

-- Toggle Flash Search in command mode
keymap("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })

-- ============================================================================
-- FILE EXPLORER
-- ============================================================================

-- File explorer (repurposed from diagnostic float)
keymap("n", "<leader>e", function()
  -- Use Snacks if available, otherwise fallback to netrw
  if vim.fn.exists(":Snacks") == 2 then
    require("snacks").picker.explorer()
  else
    vim.cmd("Explore")
  end
end, { desc = "Toggle file explorer" })

keymap("n", "<leader>E", function()
  -- Use Snacks if available, otherwise fallback to netrw
  if vim.fn.exists(":Snacks") == 2 then
    require("snacks").picker.explorer({ focus = true })
  else
    vim.cmd("Explore")
  end
end, { desc = "Focus file explorer" })
