#!/bin/sh

systemctl is-active --quiet optimus-manager.service && prime-offload

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

slock &
exec bspwm
