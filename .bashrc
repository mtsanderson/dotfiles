#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME="/home/michael/.config"
export BSPWM_SOCKET="/tmp/bspwm-socket"

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
  exec startx
fi
