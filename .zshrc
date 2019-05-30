# Prompt theme
PROMPT=$'%
%{\e[30;44m%} %n %{\e[0m%}%
%{\e[34;42m%}%{\e[0m%}%
%{\e[30;42m%} %M %{\e[0m%}%
%{\e[32;43m%}%{\e[0m%}%
%{\e[30;43m%} %~ %{\e[0m%}%
%{\e[33;46m%}%{\e[0m%}%
%{\e[30;46m%} %# %{\e[0m%}%
%(?.%
%{\e[36;49m%} %{\e[0m%}%
.%
%{\e[36;41m%}%{\e[0m%}%
%{\e[30;41m%} %? %{\e[0m%}%
%{\e[31;49m%} %{\e[0m%}%
)%
'
PS2=$'%
%{\e[30;107m%} %_ %{\e[0m%}%
%{\e[97;49m%} %{\e[0m%}%
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
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
