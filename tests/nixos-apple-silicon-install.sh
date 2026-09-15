#!/bin/sh
set -eu

repo=$(CDPATH=; cd -P -- "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT INT TERM

bin=$tmpdir/bin
release=$tmpdir/release
payload=$tmpdir/payload
asahi=$tmpdir/asahi
dest=$tmpdir/firmware
mkdir -p "$bin" "$release" "$payload" "$asahi" "$dest"

cat >"$payload/install.sh" <<'EOF'
#!/bin/sh
printf 'DISTRO=%s\nINSTALLER_DATA=%s\nREPO_BASE=%s\n' \
  "$DISTRO" "$INSTALLER_DATA" "$REPO_BASE"
EOF
chmod +x "$payload/install.sh"
tar -czf "$release/installer-v0.9.1.tar.gz" -C "$payload" install.sh
printf '{"os_list":[]}\n' >"$release/installer_data.json"
printf 'package\n' >"$release/MacBookTux.zip"

hash() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{ print $1 }'
  else
    sha256sum "$1" | awk '{ print $1 }'
  fi
}

cat >"$release/manifest.tsv" <<EOF
schema	1
release_id	test-1
repo_revision	73b7103c4e3996e3e20868d510b0e8797f279323
installer_version	v0.9.1
installer_sha256	$(hash "$release/installer-v0.9.1.tar.gz")
metadata_sha256	$(hash "$release/installer_data.json")
package_sha256	$(hash "$release/MacBookTux.zip")
EOF

cat >"$bin/uname-linux" <<'EOF'
#!/bin/sh
case "$1" in
  -s) echo Linux ;;
  -m) echo aarch64 ;;
esac
EOF
chmod +x "$bin/uname-linux"

cat >"$bin/uname-darwin" <<'EOF'
#!/bin/sh
case "$1" in
  -s) echo Darwin ;;
  -m) echo arm64 ;;
esac
EOF
chmod +x "$bin/uname-darwin"

cat >"$bin/id" <<'EOF'
#!/bin/sh
case "$1" in
  -u) echo 501 ;;
esac
EOF
chmod +x "$bin/id"

cat >"$bin/caffeinate" <<'EOF'
#!/bin/sh
[ "$1" = -dis ] && shift
exec "$@"
EOF
chmod +x "$bin/caffeinate"

cat >"$bin/sudo" <<'EOF'
#!/bin/sh
exec "$@"
EOF
chmod +x "$bin/sudo"

ln -s "$bin/uname-linux" "$bin/uname"

PATH="$bin:$PATH" "$repo/scripts/nixos-apple-silicon-install.sh" \
  --check --release-dir "$release" >"$tmpdir/linux-check.out"
grep -q 'Release test-1 is valid.' "$tmpdir/linux-check.out"

if PATH="$bin:$PATH" "$repo/scripts/nixos-apple-silicon-install.sh" \
  --release-dir "$release" >"$tmpdir/linux-install.out" 2>"$tmpdir/linux-install.err"; then
  echo 'Expected Asahi install on Linux to fail.' >&2
  exit 1
fi
grep -q 'The Asahi installer requires macOS' "$tmpdir/linux-install.err"

rm "$bin/uname"
ln -s "$bin/uname-darwin" "$bin/uname"

PATH="$bin:$PATH" "$repo/scripts/nixos-apple-silicon-install.sh" \
  --release-dir "$release" >"$tmpdir/darwin-run.out"
grep -q '^DISTRO=NixOS$' "$tmpdir/darwin-run.out"
grep -q '^INSTALLER_DATA=.*/installer/installer_data.json$' "$tmpdir/darwin-run.out"
grep -q '^REPO_BASE=.*/repo$' "$tmpdir/darwin-run.out"

printf 'changed\n' >>"$release/MacBookTux.zip"
if PATH="$bin:$PATH" "$repo/scripts/nixos-apple-silicon-install.sh" \
  --check --release-dir "$release" >"$tmpdir/bad.out" 2>"$tmpdir/bad.err"; then
  echo 'Expected a bad package hash to fail.' >&2
  exit 1
fi
grep -q 'SHA-256 mismatch for MacBookTux.zip' "$tmpdir/bad.err"

PATH="$bin:$PATH" "$repo/scripts/nixos-apple-silicon-install.sh" --rescue >"$tmpdir/rescue.out"
grep -q 'Do not delete or recreate Apple or Asahi partitions by hand.' "$tmpdir/rescue.out"

printf 'firmware\n' >"$asahi/all_firmware.tar.gz"
printf 'cache\n' >"$asahi/kernelcache.release"
"$repo/nix/apple-silicon/copy-firmware.sh" "$asahi" "$dest"
grep -q '^firmware$' "$dest/all_firmware.tar.gz"
grep -q '^cache$' "$dest/kernelcache.release"
"$repo/nix/apple-silicon/copy-firmware.sh" "$asahi" "$dest"

empty=$tmpdir/empty-asahi
mkdir -p "$empty"
"$repo/nix/apple-silicon/copy-firmware.sh" "$empty" "$dest"
if "$repo/nix/apple-silicon/copy-firmware.sh" "$empty" "$tmpdir/empty-dest" 2>"$tmpdir/empty.err"; then
  echo 'Expected missing firmware to fail.' >&2
  exit 1
fi
grep -q 'Asahi firmware archive not found' "$tmpdir/empty.err"

echo 'Apple Silicon installer launcher tests passed.'
