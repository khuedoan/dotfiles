# Arch Linux Rice

![Screenshot](https://i.imgur.com/zMZTAkm.jpg)

Pretending to be busy while watching YouTube video in Picture-in-Picture mode

## Getting Started

You can install this rice right after Arch Linux installation

**Important**:

- The install script is only tested on my machine, use it at your own risk (install dotfiles and packages only unless you know what you're doing)
- If the script is not doing everything automatically (except enter your password), there is a bug, please open an issue
- Capslock is now Ctrl when held and Esc when tapped
- Left Alt and Left Super is swapped
- Multi monitor is not working properly yet, please open a PR if you have a solution

### Prerequisites

The install script below assumes you installed Arch with [my instruction](https://github.com/khuedoan98/archguide). You can also install these dotfiles manually

You will need at least these packages for this rice to be usable (use the install script bellow for automatic installation):

Base:
`xorg-server`
`xorg-xinit`
`bspwm`
`sxhkd`
[`dmenu`](https://github.com/khuedoan98/dmenu)
[`polybar`](https://aur.archlinux.org/packages/polybar/)
[`st`](https://github.com/khuedoan98/st)

Fonts:
[`nerd-fonts-source-code-pro`](https://aur.archlinux.org/packages/nerd-fonts-source-code-pro/)
[`ttf-mac-fonts`](https://aur.archlinux.org/packages/ttf-mac-fonts/)

Optional:
[`compton-tryone-git`](https://aur.archlinux.org/packages/compton-tryone-git/)
[`slock`](https://github.com/khuedoan98/slock)

### Installation

#### The lazy way

`curl -O https://khuedoan.me/dotfiles/install.sh`

`chmod +x install.sh`

Optionally edit the install script. Then run it:

`./install.sh`

The safe options are:

- All config files
- AUR helper (trizen)
- Recommended packages
- Extra packages

Don't use the other if you don't know what you're doing:

- Intel graphics driver and Bumblebee is pretty safe if you are using laptop with Intel and NVIDIA GPU
- Unikey is for Vietnamese input method
- System config files: undervolt profile, keyboard layout remap (to use AltGr + HJKL for arrow keys)...
- Battery saver: TLP, undervolt

#### The better way

1. Fork this repo.

2. Edit the `REPO` variable in `install.sh` and commit.

3. Clone with `git clone https://github.com/YOUR_USER_NAME/dotfiles.git"`

4. Run the install script

`cd dotfiles`

`./install.sh`

### Usage

#### Quick start

`alt + /`        for help

`alt + enter`    for terminal

`alt + space`    for app launcher

`alt + ctrl + q` to quit app

The Capslock key is now Escape when tapping and Control when holding.

#### Version control

Make change to the dotfiles to suit your needs, then use `dotfiles` command instead of `git` for version control

For example:

`dotfiles add .config/foo`

`dotfiles commit`

`dotfiles push`

Check out `.aliases` for more

## Acknowledgments

- **thugcee** for [show sxhkd key bindings with fuzzy search script](https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/)
