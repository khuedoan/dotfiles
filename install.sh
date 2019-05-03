#!/bin/sh

echo -n "Install trizen (AUR helper)? (y/N) " && read aur
echo -n "Install bumblebee (for optimus NVIDIA card)? (y/N) " && read bb
[ "$bb" = "y" ] || (echo -n "Install Intel graphics driver? (y/N) " && read intel)
echo -n "Install recommended packages? (y/N) " && read pkg
echo -n "Install Vietnamese input method (fcitx-unikey)? (y/N) " && read vnim
echo -n "Install zsh plugins? (y/N) " && read zplug
echo -n "Install dotfiles? (y/N) " && read dot
echo -n "Run post-installation (auto detect hardware for polybar)? (y/N) " && read post
echo -n "Install system configuration files (login logo, touchpad, backlight)? (y/N) " && read sysconf

if [ "$aur" = "y" ]; then
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -si
    cd ..
    rm -rf trizen
fi

if [ "$pkg" = "y" ]; then
    sudo pacman --noconfirm -S xorg-server xorg-xinit xorg-setxkbmap xcape bspwm sxhkd ttf-dejavu alsa-utils xorg-xbacklight xautolock maim xclip dunst libnotify feh bc translate-shell playerctl htop glances powertop xorg-xsetroot firefox rxvt-unicode pcmanfm zathura zathura-pdf-mupdf xarchiver unrar unzip zip mpv youtube-dl aria2 tlp fzf lxappearance arc-gtk-theme papirus-icon-theme
    trizen --noconfirm -S polybar dmenu2 i3lock-next-git compton-tryone-git ttf-ms-fonts
fi

if [ "$zplug" = "y" ]; then
    git clone https://github.com/romkatv/powerlevel10k ~/.zsh/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

if [ "$bb" = "y" ]; then
    sudo pacman --noconfirm -S bumblebee mesa xf86-video-intel nvidia lib32-nvidia-utils lib32-virtualgl nvidia-settings bbswitch
    sudo gpasswd -a $USER bumblebee
    sudo gpasswd -a $USER video
    sudo systemctl enable bumblebeed.service
    # Run NVIDIA settings with optirun -b none /usr/bin/nvidia-settings -c :8
fi

if [ "$intel" = "y" ]; then
    sudo pacman --noconfirm -S xf86-video-intel
fi

if [ "$vnim" = "y" ]; then
    sudo pacman --noconfirm -S fcitx fcitx-unikey fcitx-im fcitx-configtool
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
