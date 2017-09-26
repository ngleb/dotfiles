set nocompatible
syntax on

set viminfo="NONE"

scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8

set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

set nowrap
set linebreak
set number
set noruler
set showcmd
set laststatus=2

set scrolljump=7
set scrolloff=7

if &term == "screen"
    set t_Co=256
endif

if has("gui_running")
	set guioptions-=T " toolbar
	set guioptions+=c " gui boxes
	set guioptions-=r " scrollbar
	set guioptions-=e " tabs
	set guioptions-=m " menu
	set lines=50 columns=150
	set guifont=Source\ Code\ Pro\ 12
else
	set background=dark
	colorscheme desert
endif

set nobackup
set noswapfile
set nowb
set hidden

set hlsearch
set incsearch
set ignorecase

set backspace=indent,eol,start

set formatoptions-=ro
set fo+=cr

set fileencodings=utf-8,cp1251,koi8-r,cp866
set fileformats=unix,dos,mac

" allow quit via single keypress (Q)
map Q :qa!<CR>

" Leader commands

" Edit .vimrc with \v
nmap <silent><leader>v :e ~/.vimrc<CR>

" Window movements
nmap <silent><C-h> :wincmd h<CR>
nmap <silent><C-j> :wincmd j<CR>
nmap <silent><C-k> :wincmd k<CR>
nmap <silent><C-l> :wincmd l<CR>
" Previous window
nmap <silent><C-p> :wincmd p<CR>
" Equal size windows
nmap <silent><leader>w= :wincmd =<CR>
" Swap windows
nmap <silent><leader>wx :wincmd x<CR>

" Window splitting
nmap <silent><leader>sh :split<CR>
nmap <silent><leader>sv :vsplit<CR>
nmap <silent><leader>sc :close<CR>

nmap <F8> :TagbarToggle<CR>

" Common code for encodings
function! SetFileEncodings(encodings)
    let b:myfileencodingsbak=&fileencodings
    let &fileencodings=a:encodings
endfunction
function! RestoreFileEncodings()
    let &fileencodings=b:myfileencodingsbak
    unlet b:myfileencodingsbak
endfunction

" .NFO specific
au BufReadPre *.nfo call SetFileEncodings('cp437')|set ambiwidth=single
au BufReadPost *.nfo call RestoreFileEncodings()

" Highlight anything exceeding 80 characters
" :au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Highlight trailing spaces
":au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)

" Highlight tabs between spaces
":au BufNewFile,BufRead * let b:mtabbeforesp=matchadd('ErrorMsg', '\v(\t+)\ze( +)', -1)
":au BufNewFile,BufRead * let b:mtabaftersp=matchadd('ErrorMsg', '\v( +)\zs(\t+)', -1)

" Disable syntax highlight on files bigger than 512kB
:au BufReadPost * if getfsize(bufname("%")) > 524288 | set syntax= | endif
