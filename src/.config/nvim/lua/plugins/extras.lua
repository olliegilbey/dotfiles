-- Kanagawa colorscheme (inspired by Hokusai's "The Great Wave")
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave", -- Load "wave" theme 
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}