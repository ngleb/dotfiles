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

# .bash_profile ends here
