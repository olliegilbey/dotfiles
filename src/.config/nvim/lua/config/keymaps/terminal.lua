-- Terminal & UI Toggle Keymaps
-- <leader>u for UI/toggle operations

local keymap = vim.keymap.set

-- ============================================================================
-- TERMINAL (via Snacks.nvim)
-- ============================================================================

-- Primary terminal toggle
keymap({ "n", "t" }, "<C-/>", function()
  local snacks = require("snacks")
  if snacks and snacks.terminal then
    snacks.terminal.toggle()
  else
    vim.cmd("terminal")
  end
end, { desc = "Toggle terminal" })

-- Alternative terminal keymaps (<leader>u group)
keymap("n", "<leader>ut", function()
  local snacks = require("snacks")
  if snacks and snacks.terminal then
    snacks.terminal.toggle()
  else
    vim.cmd("terminal")
  end
end, { desc = "Toggle terminal" })

-- ============================================================================
-- UI TOGGLES (<leader>u group)
-- ============================================================================

-- Zen/Focus modes
keymap("n", "<leader>uz", function()
  local snacks = require("snacks")
  if snacks and snacks.zen then
    snacks.zen()
  else
    print("Snacks.nvim zen mode not available")
  end
end, { desc = "Toggle zen mode" })

keymap("n", "<leader>uZ", function()
  local snacks = require("snacks")
  if snacks and snacks.zoom then
    snacks.zoom()
  else
    print("Snacks.nvim zoom not available")
  end
end, { desc = "Toggle zoom" })

-- Scratch buffer
keymap("n", "<leader>.", function()
  local snacks = require("snacks")
  if snacks and snacks.scratch then
    snacks.scratch()
  else
    vim.cmd("enew")
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
  end
end, { desc = "Toggle scratch buffer" })

-- Line numbers
keymap("n", "<leader>ul", function()
  vim.opt.number = not vim.opt.number:get()
end, { desc = "Toggle line numbers" })

-- Relative numbers
keymap("n", "<leader>ur", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })

-- Spell check
keymap("n", "<leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
end, { desc = "Toggle spell check" })

-- Wrap
keymap("n", "<leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = "Toggle wrap" })

-- Diagnostics
keymap("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- List chars (whitespace visualization)
keymap("n", "<leader>uL", function()
  vim.opt.list = not vim.opt.list:get()
end, { desc = "Toggle list chars" })

-- Cursor line
keymap("n", "<leader>uc", function()
  vim.opt.cursorline = not vim.opt.cursorline:get()
end, { desc = "Toggle cursor line" })

-- ============================================================================
-- QUICKFIX & LOCATION LISTS (<leader>x group)
-- ============================================================================

keymap("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open location list" })
keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open quickfix" })
keymap("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
