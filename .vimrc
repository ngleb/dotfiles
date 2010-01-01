scriptencoding utf-8
set encoding=utf-8

if ($TERM == "rxvt-unicode") && (&termencoding == "")
    set termencoding=utf-8
endif

" Несовместимость настроек с Vi
set nocompatible

" Make backspace delete lots of things
set backspace=indent,eol,start

" Включить подсветку выражения, которое ищется в тексте
set hlsearch
" При поиске перескакивать на найденный текст в процессе набора строки
set incsearch
" Игнорировать регистр букв при поиске
set ignorecase

" Размер таб-символа, отступа по << и >>
set tabstop=4
set shiftwidth=4
set softtabstop=4
" Заменять таб символ пробелами
set expandtab
" Умные табы
set smarttab
" Автоматическая расстановка отступов
set autoindent
" 'Умная' расстановка отступов
set smartindent

" При прокрутке не нужно прокручивать в самый низ
set scrolljump=7
set scrolloff=7

" Перенос строк, перенос по словам
set wrap
set linebreak

" Показывать положение курсора
set ruler
" Показывать номер строки
set number
" Отображать выполняемую команду
set showcmd
" Отображать статусную строку для каждого окна
set laststatus=2
" Дополнительная информация в статусной строке
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P

" Отключить создание бэкапов
set nobackup
" Отключить создание swap файлов
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
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
end

" Включить посдветку синтаксиса
syntax on

" Enable filetype settings
filetype on
filetype plugin on
filetype indent on

" Отключить автоматическое комментирование (не работает)
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

" Включить подсветку невидимых символов
setlocal list
" Настройка подсветки невидимых символов
setlocal listchars=tab:·\ ,trail:·
" highlight trailing spaces
:au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)
" hightlight long lines
":au BufWinEnter * let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
":au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
