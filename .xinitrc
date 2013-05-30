xrdb ~/.Xresources 
xset +fp /home/michael/.fonts
xset +fp /usr/share/fonts/local 
xset fp rehash 
xset b off
xcalib /home/michael/x230.icm &
xsetroot -cursor_name left_ptr &
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &
urxvtd &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

DEFAULT_SESSION=xmonad
case $1 in
xmonad)
nitrogen --restore &
compton -cbC
exec dbus-launch xmonad
;;

*)
nitrogen --restore &
compton -cCb &
unclutter -grab -noevents -root &
exec dbus-launch  $DEFAULT_SESSION
;;
esac
