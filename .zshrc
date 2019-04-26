# Keybindings
bindkey -v

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
# trizen -S zsh-theme-powerlevel10k-git
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# sudo pacman -S zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# sudo pacman -S zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# sudo pacman -S fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
