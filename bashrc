# -*- mode: sh -*-

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Change the window title of X terminals
case ${TERM} in
    [aEkx]term*|rxvt*|gnome*|konsole*|interix|screen*|tmux*)
		PS1='\[\033]0;\u@\h:\w\007\]'
		;;
	*)
		unset PS1
		;;
esac

if [[ ${EUID} == 0 ]] ; then
	PS1+='\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
else
	PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
export HISTIGNORE="&:ls:[bf]g:exit"

HISTSIZE=10000
HISTFILESIZE=10000

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

shopt -s cmdhist
shopt -s checkwinsize # check window size after each command
shopt -s extglob

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias e='emacsclient -n'
alias ..='cd ..'
alias ...='cd ../..'
alias hist='history | grep $1'      # requires an argument
alias ls='ls -hF --group-directories-first --color=auto'
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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# source /usr/bin/virtualenvwrapper_lazy.sh

# end of .bashrc file
