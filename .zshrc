# Disable software flow control
stty -ixon

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Key bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^[[3~' delete-char

# Change cursor shape based on vi mode
function zle-keymap-select zle-line-init zle-line-finish {
    if [ "$KEYMAP" = "vicmd" ]; then
        echo -ne '\033[2 q'
    else
        echo -ne '\033[5 q'
    fi
}
zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh_history
setopt histignorealldups sharehistory

# Aliases
source $HOME/.aliases

# Options
setopt autocd autopushd
setopt noflowcontrol

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
setopt complete_aliases
setopt no_auto_remove_slash

# Plugins
source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme \
    || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
    || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
source /usr/share/fzf/key-bindings.zsh

# Powerlevel10k settings
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf settings
export FZF_CTRL_T_COMMAND='find .'
