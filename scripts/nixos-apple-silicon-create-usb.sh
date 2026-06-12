#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: scripts/nixos-apple-silicon-create-usb.sh DISK [RELEASE]

Download the nixos-apple-silicon prebuilt installer ISO and write it to DISK.
RELEASE defaults to latest. Example:

  scripts/nixos-apple-silicon-create-usb.sh /dev/disk4
  scripts/nixos-apple-silicon-create-usb.sh /dev/disk4 release-2025-11-18

This erases the target disk.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage >&2
  exit 2
fi

disk=$1
release=${2:-latest}
repo=nix-community/nixos-apple-silicon

if [ "$release" = "latest" ]; then
  api_url="https://api.github.com/repos/$repo/releases/latest"
else
  api_url="https://api.github.com/repos/$repo/releases/tags/$release"
fi

tmpdir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT INT TERM

release_json=$tmpdir/release.json
curl -fsSL "$api_url" -o "$release_json"

iso_url=$(
  sed -n 's/.*"browser_download_url": "\(.*\.iso\)".*/\1/p' "$release_json" | head -n 1
)

if [ -z "$iso_url" ]; then
  iso_url=$(
    sed -n 's/.*"browser_download_url": "\(.*\.iso\.zst\)".*/\1/p' "$release_json" | head -n 1
  )
fi

if [ -z "$iso_url" ]; then
  echo "No .iso or .iso.zst asset found for $repo $release" >&2
  exit 1
fi

image=$tmpdir/installer.iso
case "$iso_url" in
  *.iso.zst)
    compressed=$tmpdir/installer.iso.zst
    curl -fL "$iso_url" -o "$compressed"
    if command -v zstd >/dev/null 2>&1; then
      zstd -d "$compressed" -o "$image"
    elif command -v nix >/dev/null 2>&1; then
      nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#zstd -c zstd -d "$compressed" -o "$image"
    else
      echo "zstd is required to decompress $iso_url" >&2
      exit 1
    fi
    ;;
  *)
    curl -fL "$iso_url" -o "$image"
    ;;
esac

cat <<EOF
About to erase and write:
  ISO:  $iso_url
  Disk: $disk

Type YES to continue:
EOF
read -r answer

if [ "$answer" != "YES" ]; then
  echo "Aborted."
  exit 1
fi

case "$(uname -s)" in
  Darwin)
    output_disk=$(printf '%s\n' "$disk" | sed 's#^/dev/disk#/dev/rdisk#')
    diskutil unmountDisk "$disk"
    sudo dd if="$image" of="$output_disk" bs=4m conv=sync status=progress
    ;;
  Linux)
    sudo dd if="$image" of="$disk" bs=4M conv=sync,fsync status=progress
    ;;
  *)
    echo "Unsupported platform: $(uname -s)" >&2
    exit 1
    ;;
esac

sync
echo "Installer USB is ready."
