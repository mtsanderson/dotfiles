xrdb ~/.Xresources 
xset +fp /usr/share/fonts/local 
xset +fp ~/.fonts/ 
xset fp rehash 
xset b off
nvidia-settings -l &
nitrogen --restore &
xsetroot -cursor_name left_ptr &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &
urxvtd &

compton -cbC
exec dbus-launch xmonad
