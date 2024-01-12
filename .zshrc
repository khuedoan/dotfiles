# Plugin manager
source $HOME/.zsh/zinit/zinit.zsh \
    || (git clone --depth 1 https://github.com/zdharma-continuum/zinit.git $HOME/.zsh/zinit && exec zsh)

# Theme
zinit ice depth=1 atload="source $HOME/.p10k.zsh"
zinit light romkatv/powerlevel10k

# Plugin list
zinit wait lucid light-mode depth=1 nocd for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
    atload='_zsh_autosuggest_start' zsh-users/zsh-autosuggestions \
    atload='export KEYTIMEOUT=1; MODE_CURSOR_VIINS="bar"; vim-mode-cursor-init-hook' softmoth/zsh-vim-mode \
    Aloxaf/fzf-tab \
    hlissner/zsh-autopair
zinit wait lucid is-snippet for \
    https://github.com/ahmetb/kubectl-aliases/blob/master/.kubectl_aliases \
    https://github.com/ajeetdsouza/zoxide/blob/main/zoxide.plugin.zsh \
    https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh \
    atload='GLOBALIAS_FILTER_VALUES=(z)' https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/globalias/globalias.plugin.zsh \
    as='completion' https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# Options
setopt \
    autocd \
    autopushd \
    histignorealldups \
    histignorespace \
    sharehistory

# Disable right prompt indent
ZLE_RPROMPT_INDENT=0

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Aliases
source $HOME/.aliases
