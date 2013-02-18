set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" github plugins
Bundle 'gmarik/vundle'
"Bundle 'wincent/Command-T'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'

" vim-scripts plugins
Bundle 'bufexplorer.zip'
Bundle 'Command-T'

" other sources plugins
Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

set autoread

filetype plugin on
filetype indent on
syntax on

scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8

set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

set wrap
set linebreak
set number
set noruler
set showcmd
set laststatus=2
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P

set scrolljump=7
set scrolloff=7

if has("gui")
	set guioptions-=T " toolbar
	set guioptions+=c " gui boxes
	set guioptions-=r " scrollbar
	set guioptions-=e " tabs
	set guioptions-=m " menu
	set guifont=DejaVu\ Sans\ Mono\ 10
	set cursorline
	set background=dark
	colorscheme solarized
	set lines=40 columns=120
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

" options for invisible symbols like space at the end of line
" or tabs
setlocal list
setlocal listchars=tab:·\ ,trail:·
:au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)

" Command T options (dynamicly when ruby is avaiable)
let g:CommandTMaxHeight = 10

if has('ruby')
	if has('unix')
		nnoremap <silent><C-t> :CommandT<CR>
	else
		nnoremap <silent><M-t> :CommandT<CR>
	endif

	" Leader commands
	nnoremap <leader>t :CommandT<CR>
endif
