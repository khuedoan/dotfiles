# Prompt theme
PROMPT=$'%F{green}%S %n %s%{\e[46m%}%{\e[0m%}%f%F{cyan}%S %M %s%{\e[43m%}%{\e[0m%}%f%F{yellow}%S %~ %s%{\e[44m%}%{\e[0m%}%f%F{blue}%S %(!.#.$) %s %f' 
RPROMPT=$'%(?..%F{red}%S %? %s%f)'

# Vi mode
bindkey -v
export KEYTIMEOUT=1

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
HISTFILE=~/.zsh_history
setopt histignorealldups sharehistory

# Aliases
source ~/.aliases

# Options
setopt autocd autopushd
setopt noflowcontrol

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
