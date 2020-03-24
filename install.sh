#!/bin/bash

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
        if [ "$response" = "y" ] || [[ "$@" == *"-y"* ]]; then
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

install_aur_helper() {
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    makepkg -si --noconfirm
    cd ..
    rm -rf trizen
}

install_core_packages() {
    sudo pacman --noconfirm --needed -S alsa-utils bc bspwm dunst feh fzf git libnotify maim npm playerctl sxhkd translate-shell ttf-dejavu wmctrl xautolock xcape xclip xdotool xorg-server xorg-setxkbmap xorg-xbacklight xorg-xinit xorg-xrandr xorg-xsetroot xss-lock
    trizen --noconfirm --needed -S mons nerd-fonts-source-code-pro polybar ttf-mac-fonts

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
    sudo pacman --noconfirm --needed -S arc-gtk-theme aria2 glances gvfs htop man mpv noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ntfs-3g papirus-icon-theme pcmanfm-gtk3 ranger tmux tree unrar unzip w3m xarchiver xdg-user-dirs-gtk youtube-dl zathura zathura-pdf-mupdf zip
    gpg --recv-keys EB4F9E5A60D32232BB52150C12C87A28FEAC6B20
    trizen --noconfirm --needed -S chromium-widevine chromium-vaapi-bin ttf-ms-fonts
    xdg-user-dirs-update
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
    sudo pacman --noconfirm --needed -S ibus-unikey
}

install_system_config() {
    sed -i "s/khuedoan/$USER/g" .root/etc/systemd/system/getty@tty1.service.d/override.conf
    sudo cp -rv .root/* /
}

install_battery_saver() {
    sudo pacman --noconfirm --needed -S tlp powertop
    trizen --noconfirm --needed -S intel-undervolt
    sudo systemctl enable tlp.service
    sudo systemctl enable tlp-sleep.service
    sudo intel-undervolt apply
    sudo systemctl enable intel-undervolt.service
}

create_ssh_key() {
    email=$(whiptail --inputbox "Enter email for SSH key" 10 20 3>&1 1>&2 2>&3)
    ssh-keygen -t rsa -b 4096 -C "${email}"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    # dotfiles remote set-url origin git@github.com:khuedoan98/dotfiles.git
}

install_dev_tools() {
    # VirtualBox
    sudo pacman --noconfirm --needed -S virtualbox virtualbox-host-modules-arch virtualbox-guest-iso
    trizen --noconfirm --needed -S --sudo-autorepeat-at-runtime virtualbox-ext-oracle
    # Docker
    sudo pacman --noconfirm --needed -S docker-compose
    sudo usermod -aG docker $USER
    # Python
    sudo pacman --noconfirm --needed -S python-pipenv
}

# TUI
if [ "$#" -eq 0 ]; then
    install_list=( $(whiptail --notags --title "Dotfiles" --checklist "Install list" 20 45 11 \
        install_dotfiles "All config files" on \
        install_aur_helper "AUR helper (trizen)" on \
        install_core_packages "Recommended packages" on \
        install_extra_packages "Extra packages" on \
        3>&1 1>&2 2>&3 | sed 's/"//g') )

    for install_function in "${install_list[@]}"; do
        $install_function
    done
# CLI
else
    if [ "$1" = "--minimal" ]; then
        cli_config_files=".aliases .tmux.conf .vimrc .zshrc"

        for file in $cli_config_files; do
            curl https://raw.githubusercontent.com/khuedoan98/dotfiles/master/$file > $HOME/$file
        done
    elif [ "$1" = "--all" ]; then
        install_dotfiles
        install_aur_helper
        install_core_packages
        install_extra_packages
        install_intel_graphics
        install_bumblebee
        install_unikey
        install_system_config
        install_battery_saver
        install_dev_tools
        create_ssh_key
    else
        if [[ "$@" == *"--dotfiles"* ]]; then
            install_dotfiles
        fi
        if [[ "$@" == *"--aur-helper"* ]]; then
            install_aur_helper
        fi
        if [[ "$@" == *"--packages"* ]]; then
            install_core_packages
        fi
        if [[ "$@" == *"--extra-packages"* ]]; then
            install_extra_packages
        fi
        if [[ "$@" == *"--graphics-driver"* ]]; then
            install_intel_graphics
            install_bumblebee
        fi
        if [[ "$@" == *"--unikey"* ]]; then
            install_unikey
        fi
        if [[ "$@" == *"--system-config"* ]]; then
            install_system_config
        fi
        if [[ "$@" == *"--battery-saver"* ]]; then
            install_battery_saver
        fi
        if [[ "$@" == *"--dev-tools"* ]]; then
            install_dev_tools
        fi
        if [[ "$@" == *"--ssh-key"* ]]; then
            create_ssh_key
        fi
    fi
fi
