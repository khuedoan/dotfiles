#!/bin/sh
set -eu

repo=$(CDPATH=; cd -P -- "$(dirname "$0")/.." && pwd)
release_id=$(tr -d '\r\n' < "$repo/nix/apple-silicon/release-id")
release_url=https://github.com/khuedoan/dotfiles/releases/download/apple-silicon-$release_id
verified_release_dir=

usage() {
  cat <<'USAGE'
Usage:
  scripts/nixos-apple-silicon-install.sh [--check] [--release-url URL]
  scripts/nixos-apple-silicon-install.sh --check --release-dir DIRECTORY
  scripts/nixos-apple-silicon-install.sh --rescue
  scripts/nixos-apple-silicon-install.sh --linux-rescue [REPO_URL]

On Apple Silicon macOS, download and verify the pinned NixOS image release,
then start the official Asahi installer. The Asahi installer owns all APFS,
partition, firmware, and Apple boot-policy changes.

On Linux, --check verifies a local or remote release. The default with no
flags, or --linux-rescue, runs the USB live-installer path.

The first install still requires the normal RecoveryOS approval step. After
that step, reboot into the installed NixOS system. No USB drive is required.

Options:
  --check              Verify the release without starting the installer.
  --release-url URL    Use another immutable release directory URL.
  --release-dir DIR    Verify or install a local release directory.
  --rescue             Print recovery options without changing the system.
  --linux-rescue       Run the USB live NixOS installer path.
  -h, --help           Show this help.
USAGE
}

die() {
  echo "$*" >&2
  exit 1
}

sha256() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{ print $1 }'
  else
    sha256sum "$1" | awk '{ print $1 }'
  fi
}

manifest_value() {
  key=$1
  file=$2
  awk -F '\t' -v key="$key" '
    $1 == key { count++; value = substr($0, length($1) + 2) }
    END { if (count == 1) print value; else exit 1 }
  ' "$file" || die "Manifest field '$key' must occur exactly once."
}

verify_hash() {
  file=$1
  expected=$2
  actual=$(sha256 "$file")
  [ "$actual" = "$expected" ] || die "SHA-256 mismatch for $(basename "$file")."
}

print_rescue() {
  cat <<'EOF'
Apple Silicon NixOS recovery:

1. Hold the power button at startup and select macOS.
2. For a bad NixOS generation, select an older entry in systemd-boot.
3. For missing device firmware, run the official Asahi installer from macOS
   and select "Rebuild vendor firmware package".
4. For a damaged stub or EFI partition, use the upstream UEFI repair guide.

Do not delete or recreate Apple or Asahi partitions by hand.
EOF
}

install_from_linux() {
  [ "$#" -le 1 ] || {
    usage >&2
    exit 2
  }
  [ "$(uname -s)" = Linux ] || die "The USB live installer path requires Linux."
  [ "$(id -u)" -eq 0 ] || die "Run this script as root from the NixOS installer."

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
      die "$config_dir already exists and is not empty."
    fi
    git_cmd clone "$repo_url" "$config_dir"
  fi

  "$config_dir/nix/apple-silicon/copy-firmware.sh" "$target/boot/asahi" "$firmware_dir"

  if ! nix_cmd eval "path:$config_dir#nixosConfigurations.$flake.config.hardware.asahi.extractPeripheralFirmware" |
    grep -qx true; then
    die "Firmware was copied, but the MacBookTux flake cannot see it."
  fi

  nixos-install --flake "path:$config_dir#$flake"
}

verify_release() {
  local_release_dir=$1
  pin_release_id=$2
  work_dir=$3

  if [ -n "$local_release_dir" ]; then
    release_dir=$(CDPATH=; cd -P -- "$local_release_dir" && pwd)
  else
    release_dir=$work_dir/release
    mkdir -p "$release_dir"
    curl -fL "$release_url/manifest.tsv" -o "$release_dir/manifest.tsv"
  fi

  manifest=$release_dir/manifest.tsv
  [ -f "$manifest" ] || die "Release manifest not found: $manifest"

  schema=$(manifest_value schema "$manifest")
  manifest_release=$(manifest_value release_id "$manifest")
  repo_revision=$(manifest_value repo_revision "$manifest")
  installer_version=$(manifest_value installer_version "$manifest")
  installer_sha256=$(manifest_value installer_sha256 "$manifest")
  metadata_sha256=$(manifest_value metadata_sha256 "$manifest")
  package_sha256=$(manifest_value package_sha256 "$manifest")

  [ "$schema" = 1 ] || die "Unsupported release manifest schema: $schema"
  if [ -n "$pin_release_id" ]; then
    [ "$manifest_release" = "$pin_release_id" ] || die "Release ID mismatch: $manifest_release"
  fi
  printf '%s\n' "$repo_revision" | grep -Eq '^[0-9a-f]{40}$' || die "Invalid repository revision."
  printf '%s\n' "$installer_version" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$' || die "Invalid Asahi installer version."
  for digest in "$installer_sha256" "$metadata_sha256" "$package_sha256"; do
    printf '%s\n' "$digest" | grep -Eq '^[0-9a-f]{64}$' || die "Invalid SHA-256 digest in manifest."
  done

  installer_name=installer-$installer_version.tar.gz
  for name in "$installer_name" installer_data.json MacBookTux.zip; do
    if [ ! -f "$release_dir/$name" ]; then
      [ -z "$local_release_dir" ] || die "Release file not found: $release_dir/$name"
      curl -fL "$release_url/$name" -o "$release_dir/$name.part"
      mv "$release_dir/$name.part" "$release_dir/$name"
    fi
  done

  verify_hash "$release_dir/$installer_name" "$installer_sha256"
  verify_hash "$release_dir/installer_data.json" "$metadata_sha256"
  verify_hash "$release_dir/MacBookTux.zip" "$package_sha256"

  echo "Release $manifest_release is valid."
  verified_release_dir=$release_dir
}

run_asahi_installer() {
  release_dir=$1
  work_dir=$2
  manifest=$release_dir/manifest.tsv
  installer_version=$(manifest_value installer_version "$manifest")
  manifest_release=$(manifest_value release_id "$manifest")
  installer_name=installer-$installer_version.tar.gz

  installer_dir=$work_dir/installer
  repo_dir=$work_dir/repo
  mkdir -p "$installer_dir" "$repo_dir/os"
  tar -xzf "$release_dir/$installer_name" -C "$installer_dir"
  cp "$release_dir/installer_data.json" "$installer_dir/installer_data.json"
  ln -s "$release_dir/MacBookTux.zip" "$repo_dir/os/MacBookTux.zip"

  echo "Starting the Asahi installer for NixOS release $manifest_release."
  echo "You must complete Apple's RecoveryOS approval step after it finishes."

  maybe_sudo=
  if [ "$(id -u)" -ne 0 ]; then
    maybe_sudo=sudo
  fi

  cd "$installer_dir"
  # caffeinate keeps the Mac awake while Asahi resizes APFS.
  caffeinate -dis $maybe_sudo env \
    DISTRO=NixOS \
    INSTALLER_DATA="$installer_dir/installer_data.json" \
    REPO_BASE="$repo_dir" \
    REPORT= \
    REPORT_TAG= \
    ./install.sh
}

check_only=false
local_release_dir=
release_url_set=false
linux_rescue=false
positional=

while [ "$#" -gt 0 ]; do
  case "$1" in
    --check)
      check_only=true
      ;;
    --release-url)
      [ "$#" -ge 2 ] || die "--release-url requires a URL."
      release_url=$2
      release_url_set=true
      shift
      ;;
    --release-dir)
      [ "$#" -ge 2 ] || die "--release-dir requires a directory."
      local_release_dir=$2
      shift
      ;;
    --rescue)
      print_rescue
      exit 0
      ;;
    --linux-rescue)
      linux_rescue=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      usage >&2
      exit 2
      ;;
    *)
      [ -z "$positional" ] || {
        usage >&2
        exit 2
      }
      positional=$1
      ;;
  esac
  shift
done

if [ "$linux_rescue" = true ]; then
  [ "$check_only" = false ] && [ -z "$local_release_dir" ] || die "--linux-rescue cannot be combined with --check or --release-dir."
  if [ -n "$positional" ]; then
    install_from_linux "$positional"
  else
    install_from_linux
  fi
  exit 0
fi

if [ -n "$positional" ]; then
  if [ "$(uname -s)" = Linux ] && [ "$check_only" = false ] && [ -z "$local_release_dir" ]; then
    install_from_linux "$positional"
    exit 0
  fi
  usage >&2
  exit 2
fi

if [ "$check_only" = false ] && [ -z "$local_release_dir" ] && [ "$release_url_set" = false ]; then
  case "$(uname -s)" in
    Darwin)
      ;;
    Linux)
      install_from_linux
      exit 0
      ;;
    *)
      die "Unsupported platform: $(uname -s)"
      ;;
  esac
fi

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT INT TERM

pin_release_id=
if [ -z "$local_release_dir" ] && [ "$release_url_set" = false ]; then
  pin_release_id=$release_id
fi

verify_release "$local_release_dir" "$pin_release_id" "$work_dir"

if [ "$check_only" = true ]; then
  exit 0
fi

[ "$(uname -s)" = Darwin ] || die "The Asahi installer requires macOS. Use --check to verify a release."
[ "$(uname -m)" = arm64 ] || die "This installer requires an Apple Silicon Mac."

run_asahi_installer "$verified_release_dir" "$work_dir"
