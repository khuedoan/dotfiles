# Include custom scripts in $PATH
export PATH="$PATH:$HOME/.local/bin"

# SSH with TPM
[[ -z "$SSH_AUTH_SOCK" && -S "$XDG_RUNTIME_DIR/ssh-tpm-agent.sock" ]] &&
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-tpm-agent.sock"

# Go
export GOPATH="$HOME/.local"

# Rust
export CARGO_HOME="$HOME/.local"

# Pixel-perfect Firefox touchpad scrolling
export MOZ_USE_XINPUT2=1

# Vim
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'

# Fix Java application renders as a plain gray box
export _JAVA_AWT_WM_NONREPARENTING=1

# fzf
export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude .git --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--color=16 --layout=reverse --cycle'

# agents
export OPENCODE_ENABLE_EXA=1
export PI_OFFLINE=1
