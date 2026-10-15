# Apple Silicon installer

Status: prototype. Do not use it on a real disk until all release gates pass.

## Goals

- Start the install with one repository command on macOS.
- Use no USB drive and no live Linux install session.
- Boot the installed `MacBookTux` NixOS generation after RecoveryOS approval.
- Keep all Apple partition changes in the official Asahi installer.
- Keep the existing USB flow as a rescue option.

The design does not remove Apple's RecoveryOS approval. It also does not add a
general installer for other hosts.

## Design

The official Asahi installer installs a custom NixOS image. Asahi owns the APFS
resize, partition creation, the stub macOS system, machine firmware collection,
and Apple boot policy. This repository supplies an ext4 root image and the files
for the dedicated EFI system partition.

The user runs one command from macOS:

```sh
./scripts/nixos-apple-silicon-install.sh
```

The user completes the RecoveryOS approval that Apple requires. The next Linux
boot starts the installed NixOS generation.

## Build contract

`nix/apple-silicon/contract.nix` owns the release id, partition labels, Asahi
metadata, and installer pin. `nix/apple-silicon/release-id` is the single
release-id file. The launcher and the Nix package both read it.

Build the release directory on `aarch64-linux`:

```sh
nix build .#packages.aarch64-linux.apple-silicon-installer-release
```

The output contains `manifest.tsv`, `installer_data.json`,
`MacBookTux.zip`, and the pinned official Asahi installer. Publish all four
files under the immutable release URL in the launcher. Copy the generated
`manifest.tsv` to
`nix/apple-silicon/releases/${RELEASE_ID}/manifest.tsv`, commit that trusted
copy, then publish the same manifest and the other three files. Do not rebuild
the image after adding the trusted copy. To change a published image, use a new
release ID and build a new release.

The default macOS launcher requires the trusted copy before it downloads any
files. It compares the downloaded manifest with that copy before it reads the
manifest fields. An explicit `--release-url` override and local `--release-dir`
checks do not use a trusted copy. The current prototype has no approved release
manifest. The default install stops until the release is built and approved.

Verify that directory on any OS:

```sh
./scripts/nixos-apple-silicon-install.sh --check --release-dir ./result
```

The package has two partitions. The Asahi installer creates a 1 GB FAT ESP
with label `EFI - NIXOS`. It writes the ext4 `root.img`, with label `nixos`, to
an expandable Linux partition. These labels are part of the host configuration
contract.

The root image is the `MacBookTux` closure. First boot is that generation. There
is no extra image-only NixOS configuration.

The bootloader loads the ESP's `vendorfw/firmware.cpio` before the NixOS initrd.
The kernel can then use device firmware before drivers start. The initrd keeps
the firmware in `/run/asahi-firmware` and links `/lib/firmware/vendor` to it in
the new root. The pinned Asahi kernel searches this directory after the NixOS
firmware path.

Before the first root mount, the initrd replaces the image UUID with a random
UUID. After switch-root, systemd grows the ext4 file system, loads the Nix
database, and copies `firmware.cpio` into `/etc/nixos`. A later `nixos-rebuild`
includes the copied archive in the initrd and the NixOS firmware derivation.
Use a `path:` flake reference when rebuilding a Git checkout so that Nix can
read the ignored firmware file.

## Release gates

Do not publish the first install release until a spare supported Mac passes all
of these checks:

1. The pinned Asahi installer accepts the generated metadata and ZIP without a
   source change.
2. The first Linux boot is the installed NixOS generation. There is no hidden
   installer boot.
3. m1n1, U-Boot, systemd-boot, the kernel, and the initrd boot as one pinned
   set.
4. Device firmware works before and after switch-root.
5. Root growth and an interrupted first boot can run again without formatting
   a partition.
6. macOS stays available in the Apple boot picker after each failure test.

Run the boot-service test on `x86_64-linux`:

```sh
nix build .#checks.x86_64-linux.apple-silicon-first-boot
```

The test checks root growth, UUID replacement, firmware persistence, and a
second boot in a VM. It uses a test firmware archive. QEMU cannot prove Apple
boot policy or device firmware behavior.

## Alternatives

An internal live installer also removes the USB drive. It needs one boot to run
`nixos-install` and a second boot to start the installed system. It also keeps a
large installer partition. This does not meet the target flow.

Direct partition changes from the macOS script would copy safety-sensitive
logic from Asahi. This design does not permit that option.

## Open checks

- Confirm that Asahi installer `v0.9.1` accepts the local package layout.
- Confirm that the pinned kernel receives device firmware on first boot.
- Test the 1 GB ESP size with several NixOS generations.
- Test one interrupted first boot and one firmware rebuild on a supported Mac.
