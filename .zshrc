# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugin manager
source ~/.zsh/zinit/zinit.zsh || \
    git clone https://github.com/zdharma/zinit.git ~/.zsh/zinit

# Plugin list
zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light romkatv/powerlevel10k
zinit light hlissner/zsh-autopair
zinit snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

# Powerlevel10k config
source ~/.p10k.zsh

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
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh_history
setopt histignorealldups histignorespace sharehistory

# Key bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^[[P' delete-char
bindkey '^?' backward-delete-char

# Aliases
source $HOME/.aliases
