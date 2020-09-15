# Include custom scripts in $PATH
export PATH="$PATH:$HOME/.local/bin"

# Pixel-perfect Firefox touchpad scrolling
export MOZ_USE_XINPUT2=1

# Input method
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

# Vim
export VISUAL=nvim

# Fix Java application renders as a plain gray box
export _JAVA_AWT_WM_NONREPARENTING=1

# Hide emojis
export PIPENV_HIDE_EMOJIS=1
export MINIKUBE_IN_STYLE=0
