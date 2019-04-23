#!/bin/dash

# Change default apps here
##########################
terminal="rxvt-unicode"
browser="firefox"
##########################

echo -n "Install recommended packages? (y/N) "
read response
if [ $response = "y" ]; then
    echo "Installing basic packages"
    sudo pacman -S xorg-server xorg-xinit bspwm sxhkd $terminal
    trizen -S polybar dmenu2 i3lock-next-git compton-tryone-git
    echo "Installing fonts"
    sudo pacman -S ttf-dejavu
    trizen -S nerd-fonts-source-code-pro ttf-mac-fonts ttf-ms-fonts
    echo "Installing extra packages"
    sudo pacman -S alsa-utils xorg-xbacklight maim xclip dunst feh bc translation-shell playerctl \
                   htop glances
    sudo pacman -S $browser pcmanfm zathura zathura-pdf-mupdf mpv youtube-dl
    sudo pacman -S fzf zsh-auto-suggestions zsh-syntax-highlighting
    trizen -S zsh-theme-powerlevel10k-git
fi

REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/

git clone --bare $REPO $GITDIR

dotfiles() {
    /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

if ! dotfiles checkout; then
    echo -n "All of the above files will be deleted, are you sure? (y/N) "
    read response
    if [ $response = "y" ]; then
            dotfiles checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I {} rm -v {}
            dotfiles checkout &&
            dotfiles config status.showUntrackedFiles no &&
            dotfiles push --set-upstream origin master &&
            echo "Install completed!"
    else
            rm -rf $GITDIR
            echo "Installation cancelled"
    fi
fi
