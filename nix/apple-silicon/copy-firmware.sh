#!/bin/sh
set -eu

if [ "$#" -ne 2 ]; then
  echo "Usage: copy-firmware.sh ASAHI_DIR DEST_DIR" >&2
  exit 2
fi

asahi=$1
dest=$2
mkdir -p "$dest"

if [ -f "$asahi/all_firmware.tar.gz" ]; then
  cp "$asahi/all_firmware.tar.gz" "$dest/"
elif [ ! -f "$dest/all_firmware.tar.gz" ]; then
  echo "Asahi firmware archive not found in $asahi." >&2
  exit 1
fi

found=false
for kernelcache in "$asahi"/kernelcache*; do
  if [ -f "$kernelcache" ]; then
    cp "$kernelcache" "$dest/"
    found=true
  fi
done

if [ "$found" != true ]; then
  for kernelcache in "$dest"/kernelcache*; do
    if [ -f "$kernelcache" ]; then
      found=true
      break
    fi
  done
fi

if [ "$found" != true ]; then
  echo "Asahi kernelcache not found in $asahi." >&2
  exit 1
fi
