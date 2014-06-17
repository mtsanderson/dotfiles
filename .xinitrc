#!/bin/sh
#
# ~/.xinitrc
#
# Read upon calling startx

xrdb ~/.Xresources 
xset +fp ~/.fonts/ 
xset fp rehash 
fc-cache
xset b off

feh --bg-scale ~/wallpapers/alps.jpg
xsetroot -cursor_name left_ptr &
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &
#compton --opengl --vsync opengl-swc --paint-on-overlay -cCb -fD 5 -r 5 -o 0.5 -l 2 -t 2 &
compton &
urxvtd &
thunar --daemon &
sxhkd &

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
exec bspwm
