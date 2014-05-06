#!/bin/bash

setxkbmap es
xset m 0
syndaemon -t -k -i 1 -d &
xbindkeys &
dropbox &
clipbored &
gnome-screensaver &
conky | dzen2 -h 12 -ta r -x 400 -fn "-*-profont-medium-*-*-*-10-*-*-*-*-*-*-*" &


exec awesome
