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

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Plugins
# git clone https://github.com/romkatv/powerlevel10k ~/.zsh/powerlevel10k
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# sudo pacman -S fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
