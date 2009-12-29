# Check fot an interactive session
[ -z "$PS1" ] && return

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Options
set show-all-if-ambiguous on

# for git
GREP_OPTIONS="--color=auto"
export GREP_OPTIONS

# less Colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export HISTFILESIZE=10000
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"

shopt -s checkwinsize
shopt -s histappend
shopt -s cdspell
shopt -s cmdhist

PROMPT_COMMAND='history -a'

eval "`dircolors -b`"

# aliases

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias ..='cd ..'

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# functions

function gimp
{
    command gimp "$@" &
}

function evince
{
    command evince "$@" &
}

function extract()      # Handy Extract Program.
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
