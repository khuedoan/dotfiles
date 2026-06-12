# Dotfiles

Minimal, performance-focused configuration using Nix.
[Extremely snappy](#performance) without sacrificing convenience.

![Screenshot](https://github.com/user-attachments/assets/baab84b5-d5cd-46a1-813a-8004a95d2ccf)

My [`dotfiles`](./modules/dotfiles/home) are optimized for Linux, but since
they are POSIX compliant, they should work on macOS or BSD as well (as long as
the necessary packages are available).

Please feel free to copy bits and pieces that you like ;)

## Overview

Repository layout:

- `flake.nix`: entrypoint
- `hosts/`: one per machine, each host sets hostname, username, and imports the
  modules it needs.
- `base/`: shared baseline
- `modules/` composable modules that hosts can mix and match:
  - `cli`: shared command-line tools and development packages
  - `gui`: graphical apps and desktop settings for non-headless machines
  - `dotfiles`: configuration for nvim, tmux, zsh, fzf, sway, and more!
  - `personal`: personal-machine configuration
  - `work`: work-specific packages and configuration
- Modules follow this pattern:
  - `default.nix`: entrypoint (Nix convention)
  - `darwin.nix`: Darwin override
  - `linux.nix`: Linux override

## Customize the configuration

Fork this repo, then:

- Add a new host to `hosts/${HOSTNAME}.nix` (or update an existing
one) to match your machine and it to `flake.nix`
- Customize the host's composable modules
- Set your username and hostname
- Replace the SSH public keys and dotfiles repository URLs (if you don't want to use my dotfiles)
- Replace any host-specific hardware settings
- Follow installation and usage instruction below
- Customize the rest of the repo for your needs and clean up things that you
  don't use

## Installation

Review the base, hosts, and modules directories and adjust the configuration to
match your machines before installing.

### NixOS

Boot into the NixOS live ISO, then install the tools needed for the initial
bootstrap:

```sh
nix-shell -p git gnumake neovim disko
```

Clone the repository and run the installer:

```sh
git clone https://github.com/khuedoan/dotfiles
cd dotfiles
make install host=HOSTNAME disk=/dev/DISK
```

Replace `HOSTNAME` with the host module you want to install and `/dev/DISK` with
the target disk device.

### macOS

Before the first run:

- Update the hostname and `primaryUser.username` values in `hosts/`
- Go to `Settings > Privacy & Security > Full Disk Access` and allow Terminal

Clone the repository and apply the configuration:

```sh
git clone https://github.com/khuedoan/dotfiles
cd dotfiles
make switch host=HOSTNAME
```

Replace `HOSTNAME` with the matching entry in `flake.nix`. The rebuild script
installs Nix and Homebrew automatically on a fresh macOS system if they are not
already present.

Then reboot.

### Apple Silicon dual boot

On macOS, write the matching upstream installer ISO to a USB drive:

```sh
./scripts/nixos-apple-silicon-create-usb.sh /dev/diskN release-2025-11-18
```

Run the Asahi installer:

```sh
curl https://alx.sh | sh
```

Choose `UEFI environment only` and name it `NixOS`, which creates the
`EFI - NIXOS` ESP expected by `hosts/MacBookTux.nix`.

Boot the USB installer, create and format only the Linux root partition:

```sh
sgdisk /dev/nvme0n1 -n 0:0 -s
sgdisk /dev/nvme0n1 -p
mkfs.ext4 -L nixos /dev/nvme0n1pN
```

Replace `N` with the new Linux partition number, then run the install helper:

```sh
nix-shell -p git neovim zsh gnumake
git clone https://github.com/khuedoan/dotfiles
cd dotfiles
./scripts/nixos-apple-silicon-install.sh
```

## Usage

Diff the new configuration against the current system profile:

```sh
make diff
```

Apply changes on an installed machine:

```sh
make switch
```

Update packages:

```sh
make update
```

Build a specific host without switching:

```sh
make build host=HOSTNAME
```

Clean up Nix store:

```sh
make clean
```

Temporarily change the default config location
(useful for quickly trying out a new config without running `make`,
or updating the Neovim plugin lock file):

```sh
export XDG_CONFIG_HOME="${PWD}/modules/dotfiles/home/.config"
```

```
nvim
:lua vim.pack.update()
```

## Testing

GitHub Actions builds all NixOS and Darwin hosts, then applies the test hosts.

You can also test this locally in VMs:

NixOS:

1. `make test` <!-- TODO add test VM back -->

macOS:

1. Install [UTM](https://getutm.app)
2. Download [macOS IPSW recovery file](https://ipsw.me/product/Mac)
3. Create a macOS VM in UTM using the downloaded IPSW file
4. Run `xcode-select --install` in the new VM
5. (Optional) Clone the VM to a new one for easy rollback ([UTM doesn't support snapshot yet](https://github.com/utmapp/UTM/issues/2688)) <!-- TODO -->
6. Follow [the above steps](#macos)

## Performance

I always try to lazy load where possible.
This section attempts to demonstrate how snappy it is.

> - Last updated: December 7, 2023
> - Hardware: Ryzen 5 5600X, 32GB of RAM, running NixOS 23.11

Opening Zsh:

`time zsh -i -c exit` (47ms)

```
zsh -i -c exit  0.04s user 0.01s system 100% cpu 0.047 total
```

Opening the terminal (including waiting for the shell):

`time foot zsh -i -c exit` (67ms)

```
foot zsh -i -c exit  0.05s user 0.02s system 103% cpu 0.067 total
```

Opening Neovim with 14 plugins:

`time nvim --headless +qa` (47ms)

```
nvim --headless +qa  0.03s user 0.01s system 83% cpu 0.047 total
```

## Acknowledgements

- [LunarVim/LunarVim Neovim config](https://github.com/ChristianChiarulli/LunarVim)
- [LunarVim/nvim-basic-ide Neovim config](https://github.com/LunarVim/nvim-basic-ide)
- [siduck76/NvChad Neovim config](https://github.com/siduck76/NvChad)
- [nvim-lua/kickstart.nvim config](https://github.com/nvim-lua/kickstart.nvim)
- [mattydebie/bitwarden-rofi script](https://github.com/mattydebie/bitwarden-rofi)
- [LazyVim/LazyVim config and lazy loading](https://github.com/LazyVim/LazyVim)
- [Vim statusline without a plugin](https://shapeshed.com/vim-statuslines)
- [Microphone tuning guide by Paul W. Frields](https://fedoramagazine.org/tune-up-your-sound-with-pulseeffects-microphones), [EasyEffects preset by MateusRodCosta](https://gist.github.com/MateusRodCosta/a10225eb132cdcb97d7c458526f93085) and the [modified version by jtrv](https://github.com/jtrv/.cfg/blob/morpheus/.config/easyeffects/input/fifine_male_voice_noise_reduction.json)
- [Swap two containers in Sway](https://www.reddit.com/r/swaywm/comments/z6t24k/comment/iy6mqxs)
- [How core Git developers configure Git](https://blog.gitbutler.com/how-git-core-devs-configure-git)
- [The Git Commands I Run Before Reading Any Code](https://piechowski.io/post/git-commands-before-reading-code)
- [Setup nix, nix-darwin and home-manager from scratch on an M1 Macbook Pro](https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050)
- [Install NixOS bare metal on Apple Silicon Macs](https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md)
