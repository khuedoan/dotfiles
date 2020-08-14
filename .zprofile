if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    systemctl is-active --quiet optimus-manager.service && sudo prime-switch > /dev/null
    exec startx &> /dev/null
fi
