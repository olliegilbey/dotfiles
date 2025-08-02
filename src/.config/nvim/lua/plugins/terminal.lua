-- Terminal integration for Warp workflow
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical Terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.3
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      -- Custom terminal commands for your workflow
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- Cargo commands for Rust development
      local cargo_test = Terminal:new({
        cmd = "cargo test",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      local cargo_run = Terminal:new({
        cmd = "cargo run",
        dir = "git_dir", 
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      -- Go commands
      local go_test = Terminal:new({
        cmd = "go test ./...",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      local go_run = Terminal:new({
        cmd = "go run .",
        dir = "git_dir",
        direction = "float", 
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      -- Python with uv
      local python_run = Terminal:new({
        cmd = "uv run python",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double", 
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      -- Key mappings for language-specific terminals  
      vim.keymap.set("n", "<leader>rt", function() cargo_test:toggle() end, { desc = "Cargo Test" })
      vim.keymap.set("n", "<leader>rr", function() cargo_run:toggle() end, { desc = "Cargo Run" })
      vim.keymap.set("n", "<leader>gt", function() go_test:toggle() end, { desc = "Go Test" })
      vim.keymap.set("n", "<leader>gr", function() go_run:toggle() end, { desc = "Go Run" })
      vim.keymap.set("n", "<leader>pr", function() python_run:toggle() end, { desc = "Python Run" })
    end,
  },
}