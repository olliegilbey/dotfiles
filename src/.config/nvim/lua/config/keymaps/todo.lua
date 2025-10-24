-- Todo.txt Keymaps
-- <leader>t prefix for all todo operations

local keymap = vim.keymap.set

-- ============================================================================
-- TODO.TXT OPERATIONS
-- ============================================================================

keymap("n", "<leader>tt", function()
  require("todotxt").toggle_todotxt()
end, { desc = "Toggle todo.txt" })

keymap("n", "<leader>td", function()
  require("todotxt").toggle_donetxt()
end, { desc = "Toggle done.txt" })

keymap("n", "<leader>ta", function()
  require("todotxt").capture_todo()
end, { desc = "Add/capture todo" })

keymap("n", "<leader>tm", function()
  require("todotxt").move_done_tasks()
end, { desc = "Move completed to done.txt" })

keymap("n", "<leader>tp", function()
  require("todotxt").cycle_priority()
end, { desc = "Cycle task priority" })

keymap("n", "<leader>ts", function()
  require("todotxt").toggle_todo_state()
end, { desc = "Toggle task completion" })

-- Sorting shortcuts
keymap("n", "<leader>tss", function()
  require("todotxt").sort_tasks()
end, { desc = "Sort tasks (default)" })

keymap("n", "<leader>tsp", function()
  require("todotxt").sort_tasks_by_priority()
end, { desc = "Sort by priority" })

keymap("n", "<leader>tsc", function()
  require("todotxt").sort_tasks_by_context()
end, { desc = "Sort by context" })

keymap("n", "<leader>tsj", function()
  require("todotxt").sort_tasks_by_project()
end, { desc = "Sort by project" })

keymap("n", "<leader>tsd", function()
  require("todotxt").sort_tasks_by_due_date()
end, { desc = "Sort by due date" })

-- ============================================================================
-- BUFFER-LOCAL KEYMAPS (in todo.txt/done.txt files)
-- ============================================================================

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "todo.txt", "done.txt" },
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    -- Toggle completion with Enter or x
    keymap("n", "<CR>", function()
      require("todotxt").toggle_todo_state()
    end, { buffer = buf, desc = "Toggle task completion" })

    keymap("n", "x", function()
      require("todotxt").toggle_todo_state()
    end, { buffer = buf, desc = "Toggle task completion" })

    -- Cycle priority with p
    keymap("n", "p", function()
      require("todotxt").cycle_priority()
    end, { buffer = buf, desc = "Cycle task priority" })
  end,
})
