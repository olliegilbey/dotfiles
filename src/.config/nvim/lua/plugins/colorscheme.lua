-- TokyoNight Theme with Transparency
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- storm, moon, night, day
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help", "nvim-tree" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
      on_colors = function(colors)
        -- Customize colors for AI development workflow
        colors.hint = colors.orange
        colors.error = "#ff0000"
      end,
      on_highlights = function(highlights, colors)
        -- Make background transparent
        highlights.Normal = { bg = "NONE" }
        highlights.NormalFloat = { bg = "NONE" }
        highlights.SignColumn = { bg = "NONE" }
        highlights.NvimTreeNormal = { bg = "NONE" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}