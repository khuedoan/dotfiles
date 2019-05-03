#!/bin/sh

echo -n "Install trizen (AUR helper)? (y/N) "
read aur
echo -n "Install recommended packages? (y/N) "
read pkg
echo -n "Install dotfiles? (y/N) "
read dot
echo -n "Run post-installation (auto detect hardware for polybar)? (y/N) "
read post
echo -n "Install system configuration files (login logo, touchpad, backlight)? (y/N) "
read sysconf

if [ "$aur" = "y" ]; then
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -si
    cd ..
    rm -rf trizen
fi

if [ "$pkg" = "y" ]; then
    echo "Installing basic packages"
    sudo pacman --noconfirm -S xf86-video-intel xorg-server xorg-xinit xorg-setxkbmap xcape bspwm sxhkd
    trizen --noconfirm -S polybar dmenu2 i3lock-next-git compton-tryone-git
    echo "Installing fonts"
    sudo pacman --noconfirm -S ttf-dejavu
    trizen --noconfirm -S nerd-fonts-source-code-pro ttf-mac-fonts ttf-ms-fonts
    echo "Installing extra packages"
    sudo pacman --noconfirm -S alsa-utils xorg-xbacklight maim xclip dunst libnotify feh bc translate-shell playerctl htop glances xorg-xsetroot
    sudo pacman --noconfirm -S firefox rxvt-unicode
    sudo pacman --noconfirm -S pcmanfm zathura zathura-pdf-mupdf mpv youtube-dl
    sudo pacman --noconfirm -S fzf zsh-completions zsh-autosuggestions zsh-syntax-highlighting
    trizen --noconfirm -S zsh-theme-powerlevel10k-git
fi

if [ "$dot" = "y" ]; then
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
        else
                rm -rf $GITDIR
                echo "Installation cancelled"
                exit 1
        fi
    fi
fi

if [ "$post" = "y" ]; then
    wificard="$(ls /sys/class/net | grep wlp)"
    ethernetcard="$(ls /sys/class/net | grep enp)"
    cputhermalzone="$(for i in /sys/class/thermal/thermal_zone*; do
                          if [ $(cat $i/type) = "x86_pkg_temp" ]; then
                              echo $i
                          fi
                      done | grep -oP "\d+")"

    [ "$wificard" ] && sed -i "s/wlp2s0/$wificard/g" ~/.config/polybar/config
    [ "$ethernetcard" ] && sed -i "s/enp0s20f0u2/$ethernetcard/g" ~/.config/polybar/config
    [ "$cpuethernetcard" ] && sed -i "s/thermal-zone\ =\ 10/thermal-zone\ =\ $cputhermalzone/g" ~/.config/polybar/config
fi

if [ "$sysconf" = "y" ]; then
    sudo cp -riv .root/* /
fi
