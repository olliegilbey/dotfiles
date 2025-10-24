-- Todo.txt integration for NeoVim
-- Note: All keymaps are now in lua/config/keymaps/todo.lua
return {
  {
    "phrmendes/todotxt.nvim",
    event = "VeryLazy", -- Load early to ensure proper initialization
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

      -- Note: Buffer-local keymaps are now in lua/config/keymaps/todo.lua
    end,
  },
}