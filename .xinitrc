#!/bin/sh

i3lock-next "Welcome, $(getent passwd $USER | cut -d ':' -f 5)" &&

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

setxkbmap -option caps:escape,ctrl:swap_lalt_lctl,lv3:ralt_switch &
sxhkd &
exec bspwm
