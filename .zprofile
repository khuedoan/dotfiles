if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  export _JAVA_AWT_WM_NONREPARENTING=1
  exec startx
fi
