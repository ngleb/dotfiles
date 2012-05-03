set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'bufexplorer.zip'

filetype plugin on
filetype indent on

set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set wrap

if has("gui_running")
	set guioptions-=T
	colorscheme desert
	set nu
endif

set nobackup
set noswapfile
set nowb

syntax enable
set encoding=utf8
set ffs=unix,dos,mac
