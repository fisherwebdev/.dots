call pathogen#infect()

syntax on
filetype plugin indent on
set t_Co=256
set background=dark
color pablo

set omnifunc=syntaxcomplete#Complete

set autoindent
set backspace=indent,eol,start  "TODO or 2?
set dir=~/.vim/tmp
set encoding=utf-8
set expandtab
set foldmethod=indent
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set showmode
set nocompatible
set noerrorbells
set nojoinspaces
set nolist
set nrformats=
set number
set ruler
set scrolloff=5
set scrolljump=5
set sidescroll=10
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set smarttab
set softtabstop=2
set tabstop=2
set tags=tags;/ "TODO: figure this out
set textwidth=80
set undolevels=1000
set viminfo='50,"50           " '=marks for x files, "=registers for x files

" TODO: experiment with the first versus the other two for literal tabs 
"match Error '\t'
syn match tab display "\t"
hi link tab Error

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

" JSX highlighting in JS via vim-jsx plugin
let g:jsx_ext_required = 0

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

" make split windows easier to navigate
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-h> <C-w>h
"map <C-l> <C-w>l
"map <C-m> <C-w>_

" bind "gb" to "git blame" for visual and normal mode.
:vmap gb :<C-U>!git blame % -L<C-R>=line("'<") <CR>,<C-R>=line("'>") <CR><CR>
:nmap gb :!git blame %<CR>
