# -*- mode: sh -*-
# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.

if [[ -f ~/.profile ]] ; then
	. ~/.profile
fi

if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/my/dev/python
source /usr/bin/virtualenvwrapper.sh

# .bash_profile ends here
