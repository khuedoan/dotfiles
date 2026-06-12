#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: scripts/nixos-apple-silicon-install.sh [REPO_URL]

Run this from the nixos-apple-silicon installer after:

  sgdisk /dev/nvme0n1 -n 0:0 -s
  mkfs.ext4 -L nixos /dev/nvme0n1pN

The script mounts the root filesystem and Asahi-created ESP, clones this
dotfiles repo, copies machine firmware into hosts/MacBookTux/firmware, and
runs nixos-install for the MacBookTux flake configuration.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -gt 1 ]; then
  usage >&2
  exit 2
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script as root from the NixOS installer." >&2
  exit 1
fi

repo_url=${1:-https://github.com/khuedoan/dotfiles}
target=/mnt
config_dir=$target/etc/nixos
flake=MacBookTux
firmware_dir=$config_dir/hosts/MacBookTux/firmware

nix_cmd() {
  nix --extra-experimental-features 'nix-command flakes' "$@"
}

git_cmd() {
  if command -v git >/dev/null 2>&1; then
    git "$@"
  else
    nix_cmd shell nixpkgs#git -c git "$@"
  fi
}

mkdir -p "$target"
if ! findmnt "$target" >/dev/null 2>&1; then
  mount /dev/disk/by-label/nixos "$target"
fi

mkdir -p "$target/boot"
if ! findmnt "$target/boot" >/dev/null 2>&1; then
  efi_partuuid=$(cat /proc/device-tree/chosen/asahi,efi-system-partition)
  mount "/dev/disk/by-partuuid/$efi_partuuid" "$target/boot"
fi

if [ ! -d "$config_dir/.git" ]; then
  if [ -e "$config_dir" ] && [ "$(find "$config_dir" -mindepth 1 -maxdepth 1 | wc -l)" -ne 0 ]; then
    echo "$config_dir already exists and is not empty." >&2
    exit 1
  fi
  git_cmd clone "$repo_url" "$config_dir"
fi

mkdir -p "$firmware_dir"
cp "$target/boot/asahi/all_firmware.tar.gz" "$firmware_dir/"

set -- "$target"/boot/asahi/kernelcache*
if [ ! -e "$1" ]; then
  echo "No kernelcache* file found in $target/boot/asahi" >&2
  exit 1
fi
cp "$@" "$firmware_dir/"

if ! nix_cmd eval "path:$config_dir#nixosConfigurations.$flake.config.hardware.asahi.extractPeripheralFirmware" |
  grep -qx true; then
  echo "Firmware files were copied, but the MacBookTux flake cannot see them." >&2
  exit 1
fi

nixos-install --flake "path:$config_dir#$flake"
