scriptencoding utf-8
set encoding=utf-8

if ($TERM == "rxvt-unicode") && (&termencoding == "")
    set termencoding=utf-8
endif

" Несовместимость настроек с Vi
set nocompatible

" Make backspace delete lots of things
set backspace=indent,eol,start

" Подсветка поиска, поиск по набору, игнорировать регистр при поиске
set hlsearch
set incsearch
set ignorecase

" Размер таб-символа, отступа по << и >>
set tabstop=4
set shiftwidth=4
set softtabstop=4
" Заменять таб-символ пробелом, ???, автоотступы, умные оступы
set expandtab
set smarttab
set autoindent
set smartindent

set scrolljump=7
set scrolloff=7

" Перенос строк, перенос по словам
set wrap
set linebreak

" Показывать положение курсора, номер строки, вводимую команду, всегда показывать статусную строку
set ruler
set number
set showcmd
set laststatus=2
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P

" Таб-символ как точка
set listchars=tab:··
set list

" Не делать бэкапы и свап-файлы
set nobackup
set noswapfile

" Не выгружать буфер, когда переключаемся на другой
set hidden

if has('gui')
    " Подсветка текущей строки
    set cursorline
    " Отключить панель инструментов aka toolbar
    set guioptions-=T
    " Отключить графические диалоги
    set guioptions+=c
    " Отключить скроллбары
    set guioptions-=r
    " Отключить графические табы, включаются текстовые
    set guioptions-=e
    " Отключить меню
    set guioptions-=m
    " Шрифт для gui-версии
    set guifont=Consolas\ 10
end

" Посдветка синтаксиса
syntax on

" Enable filetype settings
filetype on
filetype plugin on
filetype indent on

" Отключить автоматическое комментирование
set formatoptions-=ro
set fo+=cr

" Порядок распознования кодировки и формата файлов
set fileencodings=utf-8,cp1251,koi8-r,cp866
set fileformats=unix,dos,mac

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

" Visualizing tabs
" syntax match Tab /\t/
" hi Tab gui=underline guifg=blue ctermbg=blue
