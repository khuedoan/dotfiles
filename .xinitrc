#!/bin/sh

setxkbmap -option ctrl:nocaps,shift:both_capslock,altwin:swap_lalt_lwin,lv3:ralt_switch &

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

slock &
xss-lock slock &
xcape -e 'Control_L=Escape' &
sxhkd &
ibus-daemon -drx &
exec bspwm
