" Spell Check:
" Command+shift+p to toggle spell check on comments (underlines in red).
"
" Mac ProTips:
"  To further improve the text rendering on Mac OSX:
"  1. From the shell: defaults write org.vim.MacVim MMCellWidthMultiplier 0.9
"  2. Opens all files from other apps in vert split defaults write
"  org.vim.MacVim MMVerticalSplit YES
"  3. If when changing monitors, your fonts go from nice and thin to ugly and
"  bold: This should fix it:
"   defaults -currentHost write -globalDomain AppleFontSmoothing -int 1
"
" Cygwin:
" Tested and should work. AutoHotkey exist that provide an identical experience
" to the Mac OSX experience.
"
" Bundle System:
" Uses the NeoBundle system. Add bundles to ~/.vim/bundlesVimRc with:
" NeoBundle "git://github.com/youruser/something.git"
" Open New Vim Windows and it will ask you to install.
" Close and then reopen the vim window.

if &compatible
 set nocompatible " Be iMproved (Dont maintain backwards compatability with vi)
endif

filetype plugin on " Required for NeoBundle and also good.
filetype indent on " Required for NeoBundle and also good.

if has('gui_win32')
  set rtp+=~/.vim
endif

set noswapfile     " Don't make backups.
set nowritebackup  " Even if you did make a backup, don't keep it around.
set nobackup

syntax on
set virtualedit=block
set tabstop=2
set noswapfile

set number              " Enable numbering
set relativenumber      " Set relative numbering

set mouse=a
set nospell
set ic
set scs

" TODO: Set up mappings to toggle between text mode and code mode.
" Editing code
set nowrap
set wrapmargin=0
" let &textwidth=exists('g:textColumns') && !empty(g:textColumns) ? g:textColumns : 80
set nolinebreak

set hlsearch
set formatoptions+=or

let &tabstop=exists('g:tabSize') ? g:tabSize : 2
let &softtabstop=exists('g:tabSize') ? g:tabSize : 2
let &shiftwidth=exists('g:tabSize') ? g:tabSize : 2
set expandtab
set ignorecase
set infercase
let g:omni_syntax_ignorecase=1
set wildmode=full
set wildignore+=*/node_modules/**
" Including this messes up fugitive in git mergetool:
" set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
set sm!  " show matching brace/paren
set visualbell
" Should avoid "Hit Enter" annoyingness (Does *not* work)
" The final c gets rid of annoying autocomplete messages.
set shortmess+=filmnrxoOtTc
" Disable Vim's startup screen
set shortmess+=I
" Customize:
" http://vi.stackexchange.com/questions/627/how-can-i-change-vims-start-or-intro-screen



" Mac Support bootstrap
set wildignore+=*.DS_Store
set wildignore+=*/_build**

" Remove ugly folds
set nofoldenable
" nofoldenable doesn't work in diff mode so do something similar
set diffopt=filler,context:9999

" ============= Configure as Privacy Plugin =========================
" All sensitive data is not stored in your ~/.vimrc folder
" Configure the spelling language and file.
" ================================================================
set spelllang=en
set spellfile=$HOME/vim_spell/en.utf-8.add
" UndoDir:
let s:homeFolder = $HOME
let s:undoDir = s:homeFolder . '/vimUndo'
set undofile
" " Create undo dir if needed - not in your dotVim folder! It should be local to
" " your computer.
if !isdirectory(s:undoDir)
  call mkdir(s:undoDir)
endif
execute "set undodir=".s:undoDir
" Since your file/folder history may show up in a git commit!
let g:netrw_dirhistmax=0
" ================================================================

" =========================== FIX SHELL ==========================
if &shell =~# 'fish$'
    set shell=sh
endif
" ================================================================


" http://stackoverflow.com/questions/6852763/vim-quickfix-list-launch-files-in-new-tab
set switchbuf+=usetab,newtab

" A better diff link for macvim
" alias mvimdiff="mvim -O  \"+windo set diff scrollbind scrollopt+=hor nowrap\""

" All ObjC/C++ files are ObjCPP.
" All snipets for ObjC are in ~/.vim/myUltiSnippets/objcpp.snippets
au BufNewFile,BufRead *.cpp set filetype=objcpp
au BufNewFile,BufRead *.h set filetype=objcpp
au BufNewFile,BufRead *.m set filetype=objcpp


" iTerm requires the following commented code to be placed in your .bashrc in
" order for Vim to show full 256 colors.
" export CLICOLOR=1
" export TERM='xterm-256color'
" if [ -e /usr/share/terminfo/x/xterm-256color ]; then
"   export TERM='xterm-256color'
" else
"   #export TERM='xterm-color'
"   export TERM=xterm-256color
" fi
" If your terminal does *not* support 256 color, if if you want better than
" 256, and are willing to limit to base16 colorschemes you enable this:
" (You probably also need the base16 colorscheme shell script to exist
" somewhere in your path) - See the base16 docs.
" let base16colorspace="256"
set t_Co=256

" source ~/.vim/bundlesVimRc
" if filereadable(expand("~/.vim/bundlesVimRc.custom"))
"   source ~/.vim/bundlesVimRc.custom
" endif
" This is to prevent NeoBundle from having the user "Hit Enter To Continue"
" set cmdheight=20
" NeoBundleCheck
" autocmd VimEnter * exec ":set cmdheight=1"


" sensible.vim disturbs this - reset it.
set listchars = "eol:$"
