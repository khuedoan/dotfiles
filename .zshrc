# Prompt theme
PROMPT=$'%{\e[0;34m%}%B┌[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;31m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%a %b %d, %H:%M"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%}\n%{\e[0;34m%}%B└%B[%{\e[1;35m%}$%{\e[0;34m%}%B]>%{\e[0m%}%b '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
RPROMPT=%(?..%B%F{red}%?%f%b)

# Keybindings
bindkey -v
export KEYTIMEOUT=1

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
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# sudo pacman -S fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
