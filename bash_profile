# -*- mode: sh -*-

if [[ -f ~/.profile ]] ; then
	. ~/.profile
fi

if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

source /usr/bin/virtualenvwrapper.sh

# .bash_profile ends here
