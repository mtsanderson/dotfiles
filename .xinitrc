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

#nvidia-settings -l &
feh --bg-scale ~/wallpapers/geo.jpg
xsetroot -cursor_name left_ptr &
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &
#compton -cCb -fD 5 -r 5 -o 0.5 -l 2 -t 2 &
compton-git --opengl --vsync opengl-swc --paint-on-overlay -cCb -fD 5 -r 5 -o 0.5 -l 2 -t 2 &
urxvtd &
thunar --daemon &
sxhkd &

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
exec bspwm -s "$PANEL_FIFO" -p W
