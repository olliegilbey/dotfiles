-- Which-Key for AI-Friendly Command Discovery
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "classic", -- Use classic preset for bottom layout
      win = {
        no_overlap = false,
        padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
        title = false,
        title_pos = "center",
        zindex = 1000,
        bo = {},
        wo = {
          winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
      },
      layout = {
        width = { min = 20 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
      },
      plugins = { spelling = true },
      spec = {
        {
          mode = { "n", "v" },
          -- Semantic groups with native icon system integration
          -- Icons auto-detected by which-key for: find, git, code, buffer, window, search, ui, diagnostic, ai, quit, tab
          -- Explicit icons only for groups without auto-detection

          -- Auto-detected groups (no icon needed)
          { "<leader>f", group = "Find/File", desc = "File discovery & search" },
          { "<leader>g", group = "Git", desc = "Version control operations" },
          { "<leader>c", group = "Code", desc = "LSP & code intelligence" },
          { "<leader>b", group = "Buffer", desc = "Buffer management" },
          { "<leader>w", group = "Window", desc = "Window/split operations" },
          { "<leader>s", group = "Search", desc = "Advanced search operations" },
          { "<leader>u", group = "UI/Toggle", desc = "Visual toggles & UI" },
          { "<leader>x", group = "Diagnostics", desc = "Problems & quickfix" },
          { "<leader>a", group = "AI", desc = "Claude Code & AI tools" },
          { "<leader>q", group = "Quit", desc = "Exit operations" },
          { "<leader><tab>", group = "Tabs", desc = "Tab operations" },

          -- Explicit icons (no auto-detection)
          { "<leader>gh", group = "Hunks", icon = "󰦒", desc = "Git hunk operations (Gitsigns)" },
          { "<leader>l", group = "Language", icon = "󰌘", desc = "Context-aware language tools" },
          { "<leader>t", group = "Todo", icon = "󰄲", desc = "Todo.txt task management" },
          { "<leader>ts", group = "Sort", icon = "󰒺", desc = "Sort tasks by..." },
          { "[", group = "Previous", icon = "󰒮", desc = "Navigate to previous..." },
          { "]", group = "Next", icon = "󰒭", desc = "Navigate to next..." },
          { "g", group = "Goto", icon = "󰈺", desc = "LSP navigation" },
          { "gs", group = "Surround", icon = "󰅪", desc = "Surround operations" },
        },
      },
    },
  },
}