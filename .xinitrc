xrdb ~/.Xresources 
xset +fp /home/michael/.fonts
xset +fp /usr/share/fonts/local 
xset fp rehash 
xset b off
xcalib /home/michael/x230.icm &
xsetroot -cursor_name left_ptr &
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape' &
urxvtd &

DEFAULT_SESSION=xmonad
case $1 in
xmonad)
#hsetroot -fill /home/michael/Pictures/wallpapers/void.png
nitrogen --restore &
compton -cbC
exec dbus-launch xmonad
;;

dwm)
hsetroot -fill /home/michael/Pictures/mountain-alps.jpg &
#conky -qc /home/michael/.xmonad/.conky_dzen | dzen2 -x '666' -w '700' -h '12' -ta 'r' -bg '#222222' -fg '#bbbbbb' -y '0' -fn '-*-lime-*-*-*-*-*-*-*-*-*-*-*-*' &
#conky -qc /home/michael/.xmonad/.conky_dzen | while read -r; do xsetroot -name "$REPLY"; done &
exec dbus-launch dwm-launch
;;

i3)
exec dbus-launch i3
;;

fvwm)
exec dbus-launch fvwm
;;

icewm)
exec dbus-launch icewm
;;

*)
#hsetroot -fill /home/michael/Pictures/wallpapers/rainy.png &
nitrogen --restore &
compton -cCb &
unclutter -grab -noevents -root &
exec dbus-launch  $DEFAULT_SESSION
;;
esac
