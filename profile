# -*- mode: sh -*-

export MOZ_WEBRENDER=1
export MOZ_USE_XINPUT2=0
export MOZ_PLUGIN_PATH="/usr/lib64/nsbrowser/plugins"
export GPODDER_HOME=$HOME/my/gpodder
export LIBVIRT_DEFAULT_URI="qemu:///system"
export WINEDLLOVERRIDES=winemenubuilder.exe=d
export GTK_OVERLAY_SCROLLING=0
export PATH=$PATH:/var/lib/flatpak/exports/bin

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev

export CC="clang"
export CFLAGS="-fsanitize=signed-integer-overflow -fsanitize=undefined -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wshadow"
export LDLIBS="-lcrypt -lcs50 -lm"
