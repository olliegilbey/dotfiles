":vmap  :vnoremap  :vunmap  :vmapclear	    yes      yes
"":xmap  :xnoremap  :xunmap  :xmapclear	    yes       -
":smap  :snoremap  :sunmap  :smapclear	    -	     yes

"*mapmode-ic* *mapmode-i* *mapmode-c* *mapmode-l*
""Some commands work both in Insert mode and Command-line mode, some not:
"commands:				      modes: ~
"Insert  Command-line	Lang-Arg ~
"":map!  :noremap!  :unmap!  :mapclear!	    yes	       yes	   -
":imap  :inoremap  :iunmap  :imapclear	    yes		-	   -
"":cmap  :cnoremap  :cunmap  :cmapclear	     -	       yes	   -
":lmap  :lnoremap  :lunmap  :lmapclear	    yes*       yes*	  yes*

"totally annoying default mapping for cap k
nmap K <nop>


" When in diff mode - Command-Shift-J/K move to next change in diff.
nmap <D-K> [c
nmap <D-J> ]c


" Always gets out of autocomplete's and just lets you enter the newline!
imap <C-Cr> <Left><Right><Cr>

" ==== My favorite way of avoiding the escape key - feel free to delete all this
" == c-l escapes and saves, avoid the pinky stretch
vmap <C-l> <Esc><Cr>
imap <C-l> <Esc>l
map <c-l> <Esc>
"while selecting (for use in snippets c-l cancels out)
smap <C-l> <Esc>
" While commanding
cmap <C-l> <C-c>





" TComment
"Toggle comment
"mapping to `gc` doesn't toggle one visually selected line - only multiples.
vmap <D-/> <c-_><c-_>
vmap <D-s-/> <c-_>b
nmap <D-/> gc$


" == c-h always does the same as c-l but also saves.
vmap <C-h> <Esc><Cr>:w<Cr>
imap <C-h> <Esc>:w<Cr>l
map <c-h> <Esc>:w<Cr>
smap <C-h> <Esc>:w<Cr>
cmap <C-h> <C-c>:w<Cr>


imap <C-k> <space><Esc>Da
imap <C-j> <esc>Ji
imap <C-o> <Esc>O
imap <S-Enter> <End><Cr>



" fast scrolling using control when in command mode (keeping the j/k paradigm)
map <C-j> <C-d>
map <C-k> <C-u>

" Make S always delete until the point where you'd want to start typing -
" with some indent plugins, or settings the desired behavior is lost - this
" restores it. (Doesn't always work - looking for better solution)
nmap S ddO

" ==== Window and split navigation ===
"Tab through your splits! (Shift tab won't ever work on terminal :( )
if has("vim_starting")
  set winwidth=1
endif


imap <c-Tab> <Esc>:tabnext<Cr>
imap <c-S-Tab> <Esc>:tabprev<Cr>
nmap <c-Tab> :tabnext<Cr>
nmap <c-S-Tab> :tabprev<Cr>

imap <D->> <Esc>:vertical resize +10<CR>
imap <D->> <Esc>:vertical resize +10<CR>
nmap <D->> :vertical resize +10<CR>
nmap <D-<> :vertical resize -10<CR>

" UltiSnips
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


" Clear search highlight when escape is pressed.
" Is really horrible on terminals.
" if has("gui_running")
"   nnoremap <esc> :noh<return><esc>
" endif
" Toggle between most recently viewed tab
map <D-L> :LastTab<CR>
imap <D-L> <Esc>:LastTab<CR>

" Quick global shortcuts for toggling the location list or quickfix list
" TODO: Use overlay for this as well.
nmap <script> <silent> <D-r> :call ToggleLocationList()<CR>
nmap <script> <silent> <D-R> :call ToggleQuickfixList()<CR>

" Clear all forms of highlight when escape is pressed in normal mode.
" Accounts for strange terminal behavior.
"
" http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
function! UnhighlightMerlinIfDefined()
  if exists(":MerlinClearEnclosing")
    execute "MerlinClearEnclosing"
  endif
endfunction



command! -nargs=* DoUnhighlightEverything :call UnhighlightMerlinIfDefined(<f-args>)
if has('gui_running')
  nnoremap <silent> <esc>  :nohlsearch<return>:DoUnhighlightEverything<return><esc>
else
  " code from above
  " Still leaves strange characters in terminal when hitting arrow keys in
  " normal mode!
  " augroup no_highlight
  "   autocmd TermResponse * nnoremap <silent> <esc> :nohlsearch<return>:DoUnhighlightEverything<return><esc>
  " augroup END
end


" Alphabetize on F5
vmap <F5> :sort ui<Cr>



"Emacs keybindings while inserting.
imap <C-a> <Esc>I
map! <c-e> <End>
map! <c-f> <Right>
map! <c-b> <Left>
map! <c-d> <Delete>
noremap! <c-n> <Down>
noremap! <c-p> <Up>
inoremap <c-g> <c-p>

" Command line (Need to map these once more for inc-search to work).
cmap <c-a> <Home>
cmap <c-e> <End>
cmap <c-f> <Right>
cmap <c-b> <Left>
cmap <c-d> <Delete>


function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nmap <D-M> :call Preserve("normal gg=G")<CR>

" Rename complete word in file
nnoremap <expr> <c-s> ':%s/\<'.expand('<cword>').'\>/'.expand('<cword>').'/g<Left><Left>'


" =====================================================================
" Macy key bindings.
" =====================================================================
" macmenu Window.Toggle\ Full\ Screen\ Mode key=<D-CR>
" This is bound in ~/.vim/.bundlesVimRc
" http://lifehacker.com/5280456/hide-your-mac-menu-bar-and-dock-for-a-cleaner-desktop

" Since it makes sense to make c-d match the mac ox/emacs style forward
" delete, c-d can't be (shift left in insert mode). Given that, we can
" make a better mac os x combo for indenting and unindenting in insert
" mode. That frees up c-t
inoremap <D-]> <c-t>
inoremap <D-[> <c-d>



" Some Textmatey Shortcuts:
imap <D-S-Enter> <End>;<Cr>
imap <D-A> <End>;


" Building:
" map <D-b> :w<Cr>:!./build.sh<Cr>
" imap <D-b> <Esc>:w<Cr>:!./build.sh<Cr>

" CmdRB to save current file and build silently - then refresh browser.
" macmenu &Tools.Make key=<nop>
" Interferes with ctrlp mappings.
" map <D-r> :w<Cr>:RRB<Cr>
" imap <D-r> <Esc>:w<Cr>:RRB<Cr>


