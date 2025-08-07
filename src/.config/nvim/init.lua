-- Modern NeoVim Configuration for AI-First Rust/Go Development
-- Optimized for Warp, Claude Code, bleeding-edge toolchain

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." }
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration
require("config.options")
require("config.keymaps")

-- Setup LazyVim with defaults
require("lazy").setup({
  spec = {
    -- Add LazyVim and import its plugins (this gives us all the defaults!)
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import/override with our custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- Use latest commits for bleeding-edge
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { 
    enabled = true, -- Auto-update plugins
    notify = false, -- Don't notify on update
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})