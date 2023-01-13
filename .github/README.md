# My ~

![Screenshot](https://user-images.githubusercontent.com/27996771/124107685-b19d8100-da8f-11eb-8e23-c5944d957c15.png)

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

### Wallpaper

[Lost In Mind by Paul Brennus](https://www.artstation.com/artwork/Z50d9R), [converted to Nord theme](https://user-images.githubusercontent.com/27996771/129466074-64c92948-96b0-4673-be33-75ee26b82a6c.jpg) palette using [ImageGoNord](https://github.com/Schrodinger-Hat/ImageGoNord)

## Acknowledgements

- [show sxhkd key bindings with fuzzy search script](https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/)
- [LunarVim/LunarVim Neovim config](https://github.com/ChristianChiarulli/LunarVim)
- [LunarVim/nvim-basic-ide Neovim config](https://github.com/LunarVim/nvim-basic-ide)
- [siduck76/NvChad Neovim config](https://github.com/siduck76/NvChad)
- [nvim-lua/kickstart.nvim config](https://github.com/nvim-lua/kickstart.nvim)
- [mattydebie/bitwarden-rofi script](https://github.com/mattydebie/bitwarden-rofi)
