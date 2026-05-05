# Nix Setup

Monorepo for my Nix-based machine setup across NixOS and macOS (for when I
don't have a Linux machine).

## Overview

Repository layout:

- `flake.nix`: entrypoint
- `hosts/`: one per machine, each host sets hostname, username, and imports the
  modules it needs.
- `base/`: shared baseline
- `modules/` composable modules that hosts can mix and match:
  - `cli`: shared command-line tools and development packages
  - `gui`: graphical apps and desktop settings for non-headless machines
  - `dotfiles`: bootstraps my dotfiles repository separately from the base
    system (moved out of base in case you don't want it)
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
git clone https://github.com/khuedoan/nix-setup
cd nix-setup
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
git clone https://github.com/khuedoan/nix-setup
cd nix-setup
make switch host=HOSTNAME
```

Replace `HOSTNAME` with the matching entry in `flake.nix`. The rebuild script
installs Nix and Homebrew automatically on a fresh macOS system if they are not
already present.

Then reboot.

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
6. Follow [the above steps](#macOS)

## Acknowledgements

- [Setup nix, nix-darwin and home-manager from scratch on an M1 Macbook Pro](https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050)
