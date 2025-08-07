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
          { "<leader><tab>", group = "tabs" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>p", group = "python" },
          { "<leader>q", group = "quit/session" },
          { "<leader>C", group = "cargo" },
          { "<leader>s", group = "search" },
          { "<leader>t", group = "todo/test/terminal" },
          { "<leader>u", group = "ui" },
          { "<leader>w", group = "windows" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
        },
      },
    },
  },
}