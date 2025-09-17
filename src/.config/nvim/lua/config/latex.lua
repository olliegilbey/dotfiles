-- LaTeX configuration for VimTeX
-- Configure Skim as PDF viewer for better live compilation experience

vim.g.vimtex_view_method = 'skim'

-- Optional: Configure Skim sync settings
-- These settings enable forward/backward search between LaTeX and PDF
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1

return {}