#!/bin/sh

i3lock-next "Welcome, $(getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1)" &&

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

setxkbmap -option ctrl:nocaps &
sleep 1 && xcape -e 'Control_L=Escape' &
sxhkd &
exec bspwm
