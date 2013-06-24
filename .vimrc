call pathogen#infect()

syntax enable

set autoindent
set backspace=indent,eol,start
set dir=~/.vim/tmp
set encoding=utf-8
set expandtab
set foldmethod=indent
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set nojoinspaces
set number
set ruler
set shiftwidth=2
set showcmd
set smartcase
set smarttab
set tabstop=2
set textwidth=80

filetype on
filetype indent plugin on

syn match tab display "\t"
hi link tab Error

filetype plugin on
set omnifunc=syntaxcomplete#Complete

" jj gets back to command mode
map! jj <Esc>

" TextMate-style fold levels
map <leader>0 :set foldlevel=99<CR>
map <leader>1 :set foldlevel=1<CR>
map <leader>2 :set foldlevel=2<CR>
map <leader>3 :set foldlevel=3<CR>
map <leader>4 :set foldlevel=4<CR>
map <leader>5 :set foldlevel=5<CR>

" Don't start out with anything folded by default
set foldlevel=99

" Newlines without insert mode
map <Leader>e O<Esc>
map <Leader>d o<esc>

" Let syntastic know about my jsl.conf
let g:syntastic_javascript_jsl_conf = "-conf `~/.jsl.conf"

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" kill any trailing whitespace on save
autocmd FileType c,cabal,cpp,haskell,javascript,php,python,readme,text
  \ autocmd BufWritePre <buffer>
  \ :call <SID>StripTrailingWhitespaces()
