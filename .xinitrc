#!/bin/sh

slock -m "Welcome, $(getent passwd $USER | cut -d ':' -f 5)" &&

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

setxkbmap -option ctrl:nocaps,shift:both_capslock,lv3:lalt_switch &
sleep 1 && xcape -e 'Control_L=Escape' &
sxhkd &
exec bspwm
