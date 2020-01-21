# Arch Linux Rice

![Screenshot](https://i.imgur.com/K02TzjR.jpg)

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

I recommend forking this repo, edit the REPO variable in the `install.sh` script so you can customize and sync your changes with GitHub using the method in the next section below,
but if you just want to try it out you can directly download the install script:

`curl -O https://khuedoan.me/dotfiles/install.sh`

`chmod +x install.sh`

Available features in the install script:

| Description                           | CLI flag            | TUI installer      |
| :------------------------------------ | :-----------------  | :----------------: |
| All config files                      | `--dotfiles`        | :heavy_check_mark: |
| AUR helper (trizen)                   | `--trizen  `        | :heavy_check_mark: |
| Recommended packages                  | `--packages`        | :heavy_check_mark: |
| Extra packages                        | `--extra-packages`  | :heavy_check_mark: |
| Intel graphics driver and Bumblebee   | `--graphics-driver` |                    |
| Unikey is for Vietnamese input method | `--unikey`          |                    |
| System config files (in `/`)          | `--system-config `  |                    |
| Battery saver                         | `--battery-saver`   |                    |
| Development tools                     | `--dev-tools    `   |                    |
| Create SSH key                        | `--ssh-key      `   |                    |

For a TUI installer:

`./install.sh`

![Screenshot](https://i.imgur.com/Z8LkkRv.jpg)

For advanced features, use CLI:

To download just the minimum for `zsh`, `vim`, and `tmux`

`./install.sh --minimal`

To run selected features, add the feature's flag in the table above, for example:

`./install.sh --dotfiles --packages --extra-packages`

To install everything (don't use this if you don't know what it actually does, read the script first):

`./install.sh --all`

### Usage

#### Quick start

Remember the key changes, you can change this in `.xinitrc`:

- Capslock is now Ctrl when held and Esc when tapped
- Left Alt and Left Super is swapped

`super + /`         for help

`super + enter`     for terminal

`super + space`     for app launcher

`super + shift + q` to quit app

#### Version control

Not available in minimal installation.
You can update by running `./install.sh --minimal` again.

Make change to the dotfiles to suit your needs, then use `dotfiles` command instead of `git` for version control

For example:

`dotfiles add .config/foo`

`dotfiles commit`

`dotfiles push`

`dotfiles pull`

Check out `.aliases` for more

## Acknowledgments

- **thugcee** for [show sxhkd key bindings with fuzzy search script](https://www.reddit.com/r/bspwm/comments/aejyze/tip_show_sxhkd_keybindings_with_fuzzy_search/)
- **ymkins** for [installer colors](https://gist.github.com/ymkins/bb0885326f3e38850bc444d89291987a)
