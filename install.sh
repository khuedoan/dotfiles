#!/bin/sh

echo -n "Install recommended packages? (y/N) "
read response
if [ "$response" = "y" ]; then
    echo "Installing basic packages"
    sudo pacman --noconfirm -S xorg-server xorg-xinit xorg-setxkbmap xcape bspwm sxhkd
    trizen --noconfirm -S polybar dmenu2 i3lock-next-git compton-tryone-git
    echo "Installing fonts"
    sudo pacman --noconfirm -S ttf-dejavu
    trizen --noconfirm -S nerd-fonts-source-code-pro ttf-mac-fonts ttf-ms-fonts
    echo "Installing extra packages"
    sudo pacman --noconfirm -S alsa-utils xorg-xbacklight maim xclip dunst libnotify feh bc translate-shell playerctl htop glances
    sudo pacman --noconfirm -S firefox rxvt-unicode
    sudo pacman --noconfirm -S pcmanfm zathura zathura-pdf-mupdf mpv youtube-dl
    sudo pacman --noconfirm -S fzf zsh-completions zsh-autosuggestions zsh-syntax-highlighting
    trizen --noconfirm -S zsh-theme-powerlevel10k-git
fi

echo -n "Install dotfiles? (y/N) "
read response
if [ "$response" = "y" ]; then
    REPO="https://github.com/khuedoan98/dotfiles.git"
    REPOSSH="git@github.com:khuedoan98/dotfiles.git"
    GITDIR=$HOME/.dotfiles/

    git clone --bare $REPO $GITDIR

    dotfiles() {
        /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
    }

    if ! dotfiles checkout; then
        echo -n "All of the above files will be deleted, are you sure? (y/N) "
        read response
        if [ "$response" = "y" ]; then
            dotfiles checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I {} rm -v {}
            dotfiles checkout
            dotfiles config status.showUntrackedFiles no
            echo -n "Set ssh url? (y/N) "
            read response
            if [ "$response" = "y" ]; then
                dotfiles remote set-url origin $REPOSSH
            fi
            echo -n "Set upstream? (y/N) "
            read response
            if [ "$response" = "y" ]; then
                dotfiles push --set-upstream origin master
            fi
        else
                rm -rf $GITDIR
                echo "Installation cancelled"
                exit 1
        fi
    fi
fi

echo -n "Run post-installation? (y/N) "
read response
if [ "$response" = "y" ]; then
    ethernetcard="$(ls /sys/class/net | grep enp)"
    wificard="$(ls /sys/class/net | grep wlp)"
    cputhermalzone="$(for i in /sys/class/thermal/thermal_zone*; do
                          if [ $(cat $i/type) = "x86_pkg_temp" ]; then
                              echo $i
                          fi
                      done | grep -oP "\d+")"

    sed -i "s/enp0s20f0u2/$ethernetcard/g" ~/.config/polybar/config
    sed -i "s/wlp2s0/$wificard/g" ~/.config/polybar/config
    sed -i "s/thermal-zone\ =\ 10/thermal-zone\ =\ $cputhermalzone/g" ~/.config/polybar/config
fi
