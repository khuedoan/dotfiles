#!/bin/bash

install_list=( $(whiptail --notags --title "Dotfiles" --checklist "Install list" 20 45 11 \
    install_dotfiles "All config files" on \
    run_post_installation "Auto detect hardware for polybar" off \
    install_aur_helper "AUR helper (trizen)" on \
    install_core_packages "Recommended packages" on \
    install_extra_packages "Extra packages" on \
    install_intel_graphics "Intel graphics driver" on \
    install_bumblebee "Bumblebee for NVIDIA Optimus" on \
    install_unikey "Unikey" on \
    install_system_config "System config files" on \
    install_battery_saver "Install battery saver for laptop" on \
    3>&1 1>&2 2>&3 | sed 's/"//g') )

install_dotfiles() {
    REPO="https://github.com/khuedoan98/dotfiles.git"
    GITDIR=$HOME/.dotfiles/

    git clone --bare $REPO $GITDIR

    dotfiles() {
        /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
    }

    if ! dotfiles checkout; then
        echo "All of the above files will be deleted, are you sure? (y/N) "
        read -r response
        if [ "$response" = "y" ]; then
            dotfiles checkout 2>&1 | grep -E "^\s+" | sed -e 's/^[ \t]*//' | xargs -d "\n" -I {} rm -v {}
            dotfiles checkout
            dotfiles config status.showUntrackedFiles no
        else
            rm -rf $GITDIR
            echo "Installation cancelled"
            exit 1
        fi
    else
        dotfiles config status.showUntrackedFiles no
    fi
}

run_post_installation() {
    wificard="$(ls /sys/class/net | grep wlp)"
    ethernetcard="$(ls /sys/class/net | grep enp)"
    cputhermalzone="$(for i in /sys/class/thermal/thermal_zone*; do
                          if [ $(cat $i/type) = "x86_pkg_temp" ]; then
                              echo $i
                          fi
                      done | grep -oP "\d+")"

    [ "$wificard" ] && sed -i "s/wlp2s0/$wificard/g" ~/.config/polybar/config
    [ "$ethernetcard" ] && sed -i "s/enp0s20f0u2u3/$ethernetcard/g" ~/.config/polybar/config
    [ "$cputhermalzone" ] && sed -i "s/thermal-zone\ =\ 10/thermal-zone\ =\ $cputhermalzone/g" ~/.config/polybar/config
}

install_aur_helper() {
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -si --noconfirm
    cd ..
    rm -rf trizen
}

install_core_packages() {
    sudo pacman --noconfirm --needed -S alsa-utils bc bspwm dunst feh git libnotify maim playerctl sxhkd translate-shell ttf-dejavu xautolock xcape xclip xdotool xorg-server xorg-setxkbmap xorg-xbacklight xorg-xinit xorg-xsetroot
    trizen --noconfirm --needed -S nerd-fonts-source-code-pro polybar ttf-mac-fonts

    # zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

    # compton
    sudo pacman --noconfirm --needed -S asciidoc libconfig
    git clone https://github.com/tryone144/compton.git
    cd compton
    make PREFIX=/usr/local
    make docs
    sudo make PREFIX=/usr/local install
    cd ..
    rm -rf compton

    # st
    git clone https://github.com/khuedoan98/st
    cd st
    sudo make clean install && sudo make clean
    cd ..
    rm -rf st

    # dmenu
    git clone https://github.com/khuedoan98/dmenu
    cd dmenu
    sudo make clean install && sudo make clean
    cd ..
    rm -rf dmenu

    # slock
    git clone https://github.com/khuedoan98/slock
    cd slock
    sudo make clean install && sudo make clean
    cd ..
    rm -rf slock
}

install_extra_packages() {
    sudo pacman --noconfirm --needed -S arc-gtk-theme aria2 firefox glances htop lxappearance mpv noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra papirus-icon-theme pcmanfm ranger unrar unzip w3m xarchiver youtube-dl zathura zathura-pdf-mupdf zip
    trizen --noconfirm --needed -S ttf-ms-fonts
}

install_intel_graphics() {
    sudo pacman --noconfirm --needed -S xf86-video-intel libva-intel-driver
}

install_bumblebee() {
    sudo pacman --noconfirm --needed -S bumblebee nvidia lib32-nvidia-utils lib32-virtualgl nvidia-settings bbswitch
    sudo gpasswd -a $USER bumblebee
    sudo gpasswd -a $USER video
    sudo systemctl enable bumblebeed.service
    sudo sed -i -e "s/#RUNTIME_PM_BLACKLIST=.*/RUNTIME_PM_BLACKLIST=\"$(lspci | grep NVIDIA | cut -b -7)\"/g" /etc/default/tlp
    # Run NVIDIA settings with optirun -b none /usr/bin/nvidia-settings -c :8
}

install_unikey() {
    sudo pacman --noconfirm --needed -S fcitx fcitx-unikey fcitx-im fcitx-configtool
}

install_system_config() {
    sed -i "s/khuedoan/$USER/g" .root/etc/systemd/system/getty@tty1.service.d/override.conf
    sudo cp -riv .root/* /
}

install_battery_saver() {
    sudo pacman --noconfirm --needed -S tlp powertop
    trizen --noconfirm --needed -S intel-undervolt
    sudo systemctl enable tlp.service
    sudo systemctl enable tlp-sleep.service
    sudo intel-undervolt apply
    sudo systemctl enable intel-undervolt.service
}

for install_function in "${install_list[@]}"; do
    $install_function
done
