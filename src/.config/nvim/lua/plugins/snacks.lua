-- Snacks.nvim configuration - customize explorer and other features
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- Configure the sidebar layout preset for narrower width
        layouts = {
          sidebar = {
            preview = "main",
            layout = {
              backdrop = false,
              width = 30, -- 10 characters less than default 40
              min_width = 30,
              height = 0,
              position = "left",
              border = "none",
            },
          },
        },
        -- Configure specific explorer source
        sources = {
          explorer = {
            layout = { preset = "sidebar", preview = false },
          },
        },
      },
    },
  },
}