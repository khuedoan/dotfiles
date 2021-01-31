# My ~

![Screenshot](https://i.imgur.com/HhjEfA3.png)

## Table of contents

<!-- vim-markdown-toc GFM -->

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
    - [Linux](#linux)
    - [macOS](#macos)
  - [Quick usage instruction](#quick-usage-instruction)
- [Features](#features)
  - [Version control](#version-control)
  - [Wallpapers](#wallpapers)
- [Acknowledgements](#acknowledgements)

<!-- vim-markdown-toc -->

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
- [`dmenu`](https://github.com/khuedoan/dmenu)
- [`st`](https://github.com/khuedoan/st)
- [`slock`](https://github.com/khuedoan/slock)
- [`picom-git`](https://aur.archlinux.org/packages/picom-git/)
- [`nerd-fonts-fira-mono`](https://aur.archlinux.org/packages/nerd-fonts-fira-mono/)

### Installation

#### Linux

```
git clone https://github.com/khuedoan/linux-setup
cd linux-setup
make init dotfiles
```

#### macOS

```
git clone https://github.com/khuedoan/macos-setup
cd linux-setup
make init dotfiles
```

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

Make change to the config files to suit your needs, then use the `git` for version control like normal. For example:

```sh
cd ~
git add .config/foo
git commit
git push
git pull
```

I used to manage my dotfiles using git bare with a `dotfiles` command but now I switched to normal `git` command.

### Wallpapers

| Original | Blured|
| :-- | :-- |
| ![Original](https://i.imgur.com/ZlvUiIZ.jpg) | ![Blured](https://i.imgur.com/C3tCYsp.jpg) |

## Acknowledgements

- **StreakyCobra** for [manage dotfiles using git bare](https://news.ycombinator.com/item?id=11070797)
- **thugcee** for [show sxhkd key bindings with fuzzy search script](https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/)
