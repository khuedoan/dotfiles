if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
    systemctl is-active --quiet optimus-manager.service && sudo prime-switch > /dev/null
    exec startx &> /dev/null
fi
