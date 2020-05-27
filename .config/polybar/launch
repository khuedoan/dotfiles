#!/bin/sh

# Terminate already running bar instances
polybar-msg cmd quit

# Auto detect hardware
export WLAN="$(ls /sys/class/net | grep wlp)"
export ETHERNET="$(ls /sys/class/net | grep enp)"
export THERMAL="$(grep -Rl "x86_pkg_temp" /sys/class/thermal/thermal_zone*/type | tr -d -c 0-9)"

# Launch Polybar, using default config location ~/.config/polybar/config
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload topbar &
done
