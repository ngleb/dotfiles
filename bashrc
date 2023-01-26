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

# set -o noclobber

HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

shopt -s cmdhist
shopt -s checkwinsize # check window size after each command
shopt -s extglob


alias e='emacsclient -n'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias hist='history | grep $1'      # requires an argument
alias qdl='wget -U QuickTime/7.6.4 '
alias ls='ls -hF --color=auto --group-directories-first'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'
alias mpvp='mpv --ao=pulse'
alias mpvn='mpv --profile=norm'
alias yt='yt-dlp'

source /usr/bin/virtualenvwrapper_lazy.sh

# end of .bashrc file
