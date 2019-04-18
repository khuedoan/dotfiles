# Arch Linux Rice

My bspwm rice on Arch Linux

## Screenshots

![Terminal](Pictures/Screenshots/screenshot-20190401-075230.png)

## Getting Started

You can install this rice right after Arch Linux installation

After installation, use `super + /` to show key bindings

### Prerequisites

You will need at least these packages for this rice to be usable
(edit [sxhkdrc](.config/sxhkd/sxhkdrc) if you want to use a different terminal):

[`bspwm`](https://www.archlinux.org/packages/community/x86_64/bspwm/)
[`sxhkd`](https://www.archlinux.org/packages/community/x86_64/sxhkd/)
[`polybar`](https://aur.archlinux.org/packages/polybar/)
[`dmenu`](https://www.archlinux.org/packages/community/x86_64/dmenu/)
[`rxvt-unicode`](https://www.archlinux.org/packages/community/x86_64/rxvt-unicode/)

Fonts:
[`nerd-fonts-source-code-pro`](https://aur.archlinux.org/packages/nerd-fonts-source-code-pro/)
[`ttf-mac-fonts`](https://aur.archlinux.org/packages/ttf-mac-fonts/)

Optional:
[`compton-tryone-git`](https://aur.archlinux.org/packages/compton-tryone-git/)
[`i3lock-next-git`](https://aur.archlinux.org/packages/i3lock-next-git/)

### Installation

#### The lazy way

```bash
curl -Lks http://bit.do/ePXGV > install.sh
bash -x install.sh
```

#### The better way

1. Fork this repo.

2. Edit the `REPO` variable in `install.sh` and commit.

3. Clone with `git clone https://github.com/YOURGITHUBUSERNAME/YOURREPONAME.git"`

4. Run the install script

```bash
cd YOURREPONAME
chmod +x install.sh
./install.sh
```

#### The best way

I know the above one is not the best, so please help me to find out ;)

### Usage

#### Quick start

`super + /`        for help

`super + enter`    for terminal

`super + space`    for app launcher

`super + ctrl + q` to quit app

The Capslock key is now Escape when tapping and Control when holding.

#### Version control

Make change to the dotfiles to suit your needs, then use `dotfiles` command instead of `git` for version control

For example:

```bash
dotfiles add .config/foo
dotfiles commit
dotfiles push
```

Check out `.aliases` for more (like `dfc` instead of `dotfiles commit`)

#### 

## Recommended packages

These are the packages I usually have in my Arch Linux system:

`sudo pacman -S alsa-utils arc-gtk-theme aria2 bbswitch bc bspwm bumblebee colordiff dunst fcitx fcitx-configtool fcitx-im fcitx-unikey feh firefox fzf glances htop lib32-nvidia-utils lib32-virtualgl libreoffice-fresh lxappearance maim mesa mpv networkmanager network-manager-applet nvidia nvidia-settings openssh papirus-icon-theme pcmanfm playerctl powertop ranger rxvt-unicode sxhkd thefuck tlp tmux translate-shell ttf-dejavu vim unrar unzip w3m xarchiver xcape xclip xf86-video-intel xorg-xbacklight xorg-xinit xorg-xsetroot youtube-dl zathura zip zsh zsh-autosuggestions zsh-syntax-highlighting`

`trizen -S compton-tryone-git dmenu2 i3lock-next-git nerd-fonts-source-code-pro polybar ttf-mac-fonts ttf-ms-fonts`

## Acknowledgments

- **thugcee** for [show sxhkd key bindings with fuzzy search script](https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/)
