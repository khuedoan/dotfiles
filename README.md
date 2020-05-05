# Arch Linux Rice

![Badge](https://gitlab.com/khuedoan/dotfiles/badges/master/pipeline.svg)

![Screenshot](https://i.imgur.com/34u3YI9.jpg)

## Getting Started

### Prerequisites

You can skip this step if you're using Arch Linux, use the install script below to install these packages automatically.

Install the following packages:

- `git`
- `xorg-server`
- `xorg-xinit`
- `bspwm`
- `sxhkd`
- [`polybar`](https://aur.archlinux.org/packages/polybar/)
- [`dmenu`](https://github.com/khuedoan98/dmenu)
- [`st`](https://github.com/khuedoan98/st)
- [`slock`](https://github.com/khuedoan98/slock)
- [`compton-tryone-git`](https://aur.archlinux.org/packages/compton-tryone-git/)
- [`nerd-fonts-source-code-pro`](https://aur.archlinux.org/packages/nerd-fonts-source-code-pro/)

### Installation

Using the method bellow, you can update new features from my repo using `dotfiles pull`, but you can't push your own customization to GitHub.

If you want to push your customization to GitHub, you need to fork this repo, change the `REPO` variable in `install.sh`, then continue running the script with the instruction below. You can't update new features from me automatically with `dotfiles pull`, but you can [do that manually](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork).

Get the install script:

`curl -O https://raw.githubusercontent.com/khuedoan98/dotfiles/master/install.sh`

`chmod +x install.sh`

Run the TUI installer:

`./install.sh`

The install dotfiles option will work with any distro, but the install packages options only works with Arch Linux (PR for other distros are welcome).

![Screenshot](https://i.imgur.com/EBTG8mx.jpg)

### Quick usage instruction

Some key mapping are changed, you can change this in `.xinitrc`:

- Capslock is now Ctrl when held and Esc when tapped using `xcape`
- Left Alt and Left Super is swapped

Some basic key bindings:

- `super + /`         for key bindings help
- `super + enter`     for terminal
- `super + space`     for app launcher
- `super + shift + q` to quit app

## Features

### Version control

The following `dotfiles` command is an alias to [manage dotfiles using git bare](https://news.ycombinator.com/item?id=11070797).

Make change to the config files to suit your needs, then use `dotfiles` command instead of `git` for version control. For example:

`dotfiles add .config/foo`

`dotfiles commit`

`dotfiles push`

`dotfiles pull`

Check out `.aliases` for more

## Acknowledgements

- **StreakyCobra** for [manage dotfiles using git bare](https://news.ycombinator.com/item?id=11070797)
- **thugcee** for [show sxhkd key bindings with fuzzy search script](https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/)
