-- Todo.txt integration for NeoVim
return {
  {
    "phrmendes/todotxt.nvim",
    event = "VeryLazy", -- Load early to ensure proper initialization
    keys = {
      { "<leader>tt", function() require("todotxt").toggle_todotxt() end, desc = "Toggle todo.txt" },
      { "<leader>td", function() require("todotxt").toggle_donetxt() end, desc = "Toggle done.txt" },
      { "<leader>ta", function() require("todotxt").capture_todo() end, desc = "Add/capture todo" },
      { "<leader>tm", function() require("todotxt").move_done_tasks() end, desc = "Move completed to done.txt" },
      { "<leader>tp", function() require("todotxt").cycle_priority() end, desc = "Cycle task priority" },
      { "<leader>ts", function() require("todotxt").toggle_todo_state() end, desc = "Toggle task completion" },
      -- Sorting shortcuts
      { "<leader>tss", function() require("todotxt").sort_tasks() end, desc = "Sort tasks (default)" },
      { "<leader>tsp", function() require("todotxt").sort_tasks_by_priority() end, desc = "Sort by priority" },
      { "<leader>tsc", function() require("todotxt").sort_tasks_by_context() end, desc = "Sort by context" },
      { "<leader>tsj", function() require("todotxt").sort_tasks_by_project() end, desc = "Sort by project" },
      { "<leader>tsd", function() require("todotxt").sort_tasks_by_due_date() end, desc = "Sort by due date" },
    },
    config = function()
      -- Ensure plugin is properly initialized
      local todotxt = require("todotxt")
      
      todotxt.setup({
        todotxt = vim.fn.expand("~/todo.txt"),
        donetxt = vim.fn.expand("~/done.txt"),
        create_commands = true, -- This creates :TodoTxt and :DoneTxt commands
      })
      
      -- Set up highlight groups for better visibility
      vim.api.nvim_set_hl(0, "TodoProject", { fg = "#00ff9f", bold = true })
      vim.api.nvim_set_hl(0, "TodoContext", { fg = "#00bfff", italic = true })
      vim.api.nvim_set_hl(0, "TodoHighPriority", { fg = "#ff4757", bold = true })
      vim.api.nvim_set_hl(0, "TodoMediumPriority", { fg = "#ffa502" })
      vim.api.nvim_set_hl(0, "TodoLowPriority", { fg = "#7bed9f" })
      
      -- Set up buffer-local keymaps for todo.txt files
      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"todo.txt", "done.txt"},
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          -- Press Enter to toggle task completion
          vim.keymap.set("n", "<CR>", function()
            require("todotxt").toggle_todo_state()
          end, { buffer = buf, desc = "Toggle task completion" })
          
          -- Additional convenient mappings in todo files
          vim.keymap.set("n", "x", function()
            require("todotxt").toggle_todo_state()
          end, { buffer = buf, desc = "Toggle task completion" })
          
          vim.keymap.set("n", "p", function()
            require("todotxt").cycle_priority()
          end, { buffer = buf, desc = "Cycle task priority" })
        end,
      })
    end,
  },
}