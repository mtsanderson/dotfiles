xrdb ~/.Xresources 
xset +fp ~/.fonts/ 
xset fp rehash 
xset b off
#nvidia-settings -l &
feh --bg-scale ~/wallpapers/geo.jpg
xsetroot -cursor_name left_ptr &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &
urxvtd &
thunar --daemon &
sxhkd &

#compton -cbC
#exec dbus-launch bspwm 
#
[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"
exec bspwm -s "$PANEL_FIFO" -p W 2> ~/.baspwm.log
