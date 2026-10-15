#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
  echo "Usage: copy-firmware.sh VENDORFW_DIR DEST_DIR" >&2
  exit 2
fi

vendorfw=$1
dest=$2
mkdir -p "$dest"

if [ -f "$vendorfw/firmware.cpio" ]; then
  cp "$vendorfw/firmware.cpio" "$dest/firmware.cpio.tmp"
  mv "$dest/firmware.cpio.tmp" "$dest/firmware.cpio"
elif [ ! -f "$dest/firmware.cpio" ]; then
  echo "Asahi firmware archive not found in $vendorfw." >&2
  exit 1
fi
