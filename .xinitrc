#!/bin/sh

setxkbmap -option ctrl:nocaps,shift:both_capslock,altwin:swap_lalt_lwin,lv3:ralt_switch &

if [ -n "$(xrandr --query | grep '^HDMI1 connected')" ]; then
    xrandr --output eDP1 --off --output DP1 --off --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI2 --off --output VIRTUAL1 --off
elif [ -n "$(xrandr --query | grep '^DP1 connected')" ]; then
    xrandr --output eDP1 --off --output DP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

slock &
xcape -e 'Control_L=Escape' &
sxhkd &
ibus-daemon -drx &
exec bspwm
