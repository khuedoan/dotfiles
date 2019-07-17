# Prompt theme
PROMPT=$'%
%{\e[30;44m%} %m %{\e[0m%}%
%{\e[34;42m%}%{\e[0m%}%
%{\e[30;42m%} %n %{\e[0m%}%
%{\e[32;43m%}%{\e[0m%}%
%{\e[30;43m%} %1~ %{\e[0m%}%
%{\e[33;49m%} %{\e[0m%}%
'
RPROMPT=$'%
%(?.%
%{\e[36;49m%}%{\e[0m%}%
.%
%{\e[31;49m%}%{\e[0m%}%
%{\e[30;41m%} %? %{\e[0m%}%
%{\e[36;41m%}%{\e[0m%}%
)%
%{\e[30;46m%} %T %{\e[0m%}%
'

# Key bindings
bindkey -v
export KEYTIMEOUT=1
bindkey '^[[P' delete-char

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
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh \
    || git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    || git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.zsh/zsh-syntax-highlighting
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
