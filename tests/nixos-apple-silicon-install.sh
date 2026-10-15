#!/bin/sh
set -eu

repo=$(CDPATH=; cd -P -- "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT INT TERM

bin=$tmpdir/bin
release=$tmpdir/release
payload=$tmpdir/payload
vendorfw=$tmpdir/vendorfw
dest=$tmpdir/firmware
mkdir -p "$bin" "$release" "$payload" "$vendorfw" "$dest"

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

printf 'firmware\n' >"$vendorfw/firmware.cpio"
"$repo/nix/apple-silicon/copy-firmware.sh" "$vendorfw" "$dest"
grep -q '^firmware$' "$dest/firmware.cpio"
"$repo/nix/apple-silicon/copy-firmware.sh" "$vendorfw" "$dest"
[ ! -e "$dest/firmware.cpio.tmp" ]

empty=$tmpdir/empty-vendorfw
mkdir -p "$empty"
"$repo/nix/apple-silicon/copy-firmware.sh" "$empty" "$dest"
if "$repo/nix/apple-silicon/copy-firmware.sh" "$empty" "$tmpdir/empty-dest" 2>"$tmpdir/empty.err"; then
  echo 'Expected missing firmware to fail.' >&2
  exit 1
fi
grep -q 'Asahi firmware archive not found' "$tmpdir/empty.err"

printf 'updated firmware\n' >"$vendorfw/firmware.cpio"
"$repo/nix/apple-silicon/copy-firmware.sh" "$vendorfw" "$dest"
grep -q '^updated firmware$' "$dest/firmware.cpio"

remote=$tmpdir/remote
fake_repo=$tmpdir/fake-repo
mkdir -p "$remote" "$fake_repo/scripts" \
  "$fake_repo/nix/apple-silicon/releases/test-1"
printf 'package\n' >"$release/MacBookTux.zip"
cp "$release"/* "$remote/"
cp "$repo/scripts/nixos-apple-silicon-install.sh" "$fake_repo/scripts/"
printf 'test-1\n' >"$fake_repo/nix/apple-silicon/release-id"
cp "$release/manifest.tsv" \
  "$fake_repo/nix/apple-silicon/releases/test-1/manifest.tsv"

cat >"$bin/curl" <<'EOF'
#!/bin/sh
set -eu

printf '%s\n' "$*" >>"$REMOTE/curl.log"
url=
output=
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o)
      output=$2
      shift
      ;;
    http*)
      url=$1
      ;;
  esac
  shift
done

cp "$REMOTE/${url##*/}" "$output"
EOF
chmod +x "$bin/curl"

REMOTE="$remote" PATH="$bin:$PATH" \
  "$fake_repo/scripts/nixos-apple-silicon-install.sh" \
  --check >"$tmpdir/remote-check.out"
grep -q 'Release test-1 is valid.' "$tmpdir/remote-check.out"

printf 'tampered\n' >>"$remote/manifest.tsv"
if REMOTE="$remote" PATH="$bin:$PATH" \
  "$fake_repo/scripts/nixos-apple-silicon-install.sh" \
  --check >"$tmpdir/tampered-remote.out" 2>"$tmpdir/tampered-remote.err"; then
  echo 'Expected a trusted manifest mismatch to fail.' >&2
  exit 1
fi
grep -q 'does not match the trusted manifest' "$tmpdir/tampered-remote.err"

REMOTE="$remote" PATH="$bin:$PATH" \
  "$fake_repo/scripts/nixos-apple-silicon-install.sh" \
  --check --release-url https://example.invalid/test-1 >"$tmpdir/override-check.out"
grep -q 'Release test-1 is valid.' "$tmpdir/override-check.out"

rm "$fake_repo/nix/apple-silicon/releases/test-1/manifest.tsv" "$remote/curl.log"
if REMOTE="$remote" PATH="$bin:$PATH" \
  "$fake_repo/scripts/nixos-apple-silicon-install.sh" \
  --check >"$tmpdir/missing-trust.out" 2>"$tmpdir/missing-trust.err"; then
  echo 'Expected a missing trusted manifest to fail.' >&2
  exit 1
fi
grep -q 'Trusted release manifest not found' "$tmpdir/missing-trust.err"
[ ! -e "$remote/curl.log" ]

echo 'Apple Silicon installer launcher tests passed.'
