#!/bin/bash

export DEFAULTWM='ion3'
export TERMCMD=/usr/bin/urxvt
export BROWSER=/usr/bin/chromium-bin
export TERMINAL=/usr/bin/urxvt
export GTK2_RC_FILES="/home/b3nd3r/.gtkrc-2.0"

#export GTK_IM_MODULE=uim
#export QT_IM_MODULE=uim
#export XMODIFIERS=@im=uim

xkbcomp $HOME/.xkb.my $DISPLAY &> ~/my/logs/xkbcomp.log &
xrdb -load ~/.Xdefaults &> /dev/null &
xbindkeys &> ~/my/logs/xbindkeys.log &

exec $DEFAULTWM &> ~/my/logs/ion3.log & wmpid=$!
    stalonetray &> ~/my/logs/stalonetray.log &
wait $wmpid
