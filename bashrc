# -*- mode: sh -*-

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

source /etc/bash/bashrc.d/bash_completion.sh

PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[0m\]'

ulimit -S -c 0 # no coredumps

export HISTCONTROL="ignoredumps"
export HISTIGNORE="&:ls:[bf]g:exit"

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
alias ping='ping -c 5'
alias ..='cd ..'
alias da='date "+%A, %B %d, %Y [%T]"'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias psg='ps -Af | grep $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)
alias qdl='wget -U QuickTime/7.6.4 '
alias mpvh='mpv --profile=hwd'
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
alias anki='anki -b ~/my/anki'

# end of .bashrc file
