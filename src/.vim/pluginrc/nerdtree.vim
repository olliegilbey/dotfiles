" Close vim if the only window left
" open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" nice arrow
let g:NERDTreeDirArrows = 1
" not so much cruft
let g:NERDTreeMinimalUI = 1
let NERDTreeShowHidden=1
let g:NERDTreeShowBookmarks = 1
hi def link NERDTreeRO Normal
hi def link NERDTreePart StatusLine
hi def link NERDTreeDirSlash Directory
hi def link NERDTreeCurrentNode Search
hi def link NERDTreeCWD Normal

" Not so much color
let g:NERDChristmasTree = 0
