# Plugin manager
source $HOME/.zsh/zinit/zinit.zsh \
    || git clone --depth 1 https://github.com/zdharma/zinit.git $HOME/.zsh/zinit

# Theme
zinit ice depth=1 atload="source $HOME/.p10k.zsh"
zinit light romkatv/powerlevel10k

# Plugin list
zinit wait lucid light-mode depth=1 for \
    atinit="zicompinit" zdharma/fast-syntax-highlighting \
    atload="_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    hlissner/zsh-autopair
zinit wait lucid is-snippet for \
    https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh \
    https://github.com/ahmetb/kubectl-aliases/blob/master/.kubectl_aliases \
    as='completion' https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
    $HOME/.aliases

# Options
setopt \
    autocd \
    autopushd \
    histignorealldups \
    histignorespace \
    sharehistory

# Disable right prompt indent
ZLE_RPROMPT_INDENT=0

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
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Key bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^[[P' delete-char
bindkey '^?' backward-delete-char
