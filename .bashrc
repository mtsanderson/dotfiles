#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
  exec startx
fi

pathdirs=(
  ~/scripts
)

for dir in $pathdirs; do
  if [ -d $dir ]; then
    PATH+=$dir
  fi
done

export EDITOR="vim"
export XDG_CONFIG_HOME="/home/michael/.config"
export BSPWM_SOCKET="/tmp/bspwm-socket"
export PANEL_FIFO=/tmp/panel-fifo
