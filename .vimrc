set tabstop=4
set shiftwidth=4
set ai
set si
set wrap

if has("gui_running")
	set guioptions-=T
	colorscheme desert
	set nu
endif

filetype plugin on
filetype indent on

set nobackup
set noswapfile
set nowb

syntax enable
set encoding=utf8
set ffs=unix,dos,mac
