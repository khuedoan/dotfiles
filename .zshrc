# Disable software flow control
stty -ixon

# Prompt theme
setopt prompt_subst
autoload -U colors && colors

PROMPT=$'%
%{$fg[black]$bg[blue]%} %m %{$reset_color%}%
%{$fg[blue]$bg[green]%}%{$reset_color%}%
%{$fg[black]$bg[green]%} %n %{$reset_color%}%
%{$fg[green]$bg[yellow]%}%{$reset_color%}%
%{$fg[black]$bg[yellow]%} %1~ %{$reset_color%}%
%{$fg[yellow]%} %{$reset_color%}%
'

RPROMPT=$'%
%(?.%
%{$fg[white]%}%~%{$reset_color%}%
.%
%{$fg[red]%} %{$reset_color%}%
%{$fg[black]$bg[red]%} %? %{$reset_color%}%
)%
'

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

# Plugins
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
    || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
source /usr/share/fzf/key-bindings.zsh

# fzf settings
export FZF_CTRL_T_COMMAND='find .'
