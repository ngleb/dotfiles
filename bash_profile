# -*- mode: sh -*-
# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.

if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

export GPODDER_HOME=$HOME/my/gpodder
export LIBVIRT_DEFAULT_URI="qemu:///system"

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/python
source /usr/bin/virtualenvwrapper.sh

# .bash_profile ends here