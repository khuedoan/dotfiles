# Include custom scripts in $PATH
export PATH="$PATH:/opt/local/bin:$HOME/.local/bin"

# Go
export GOPATH="$HOME/.local"

# Rust
export CARGO_HOME="$HOME/.local"

# Pixel-perfect Firefox touchpad scrolling
export MOZ_USE_XINPUT2=1

# Input method
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

# Vim
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'

# Fix Java application renders as a plain gray box
export _JAVA_AWT_WM_NONREPARENTING=1

# Hide emojis
export PIPENV_HIDE_EMOJIS=1
export MINIKUBE_IN_STYLE=0

# nnn
export NNN_PLUG='f:fzcd;n:bulknew;z:autojump'
