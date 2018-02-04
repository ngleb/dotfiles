# -*- mode: sh -*-

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Change the window title of X terminals
case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|interix|screen*)
		PS1='\[\033]0;\u@\h:\w\007\]'
		;;
	# screen*)
	# 	PS1='\[\033k\u@\h:\w\033\\\]'
	# 	;;
	*)
		unset PS1
		;;
esac

# PS1='\[\033]0;\u@\h:\w\007\]'

if [[ ${EUID} == 0 ]] ; then
	PS1+='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
else
	PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

ulimit -S -c 0 # no coredumps

export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
export HISTIGNORE="&:ls:[bf]g:exit"

set -o noclobber

HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend
PROMPT_COMMAND='history -a'

shopt -s cmdhist
shopt -s cdspell # correct minor spelling errors in cd
shopt -s checkwinsize # check window size after each command
shopt -s extglob

alias cdiff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias ..='cd ..'
alias da='date "+%A, %B %d, %Y [%T]"'
alias hist='history | grep $1'      # requires an argument
alias qdl='wget -U QuickTime/7.6.4 '
alias mpvh='mpv --profile=hwd'
alias dls='cd /media/data/dls'
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'

# end of .bashrc file
