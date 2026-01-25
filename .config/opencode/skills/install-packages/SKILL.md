---
name: install-packages
description: Install packages on this Nix-managed system - never use brew/apt/pacman/etc., always update Nix configuration or use nix run
---

## What I do

- Guide proper package installation on Nix-managed systems
- Prevent use of imperative package managers (brew, apt, pacman, etc.)
- Ensure reproducible system configuration

## When to use me

- When you need to install a package
- When a command is not found
- When setting up development tools or dependencies
- Before running ANY `brew`, `apt`, or similar commands

## Critical rules

- NEVER run these commands: `brew`, `apt`, `apt-get`, `pacman`, `yum`, `dnf`
- Any command that imperatively changes global system state

## Ephemeral usage for one-off commands

Use `nix run` for temporary/one-time package usage:

```sh
nix run nixpkgs#<package> -- <args>
```

Example:
```sh
nix run nixpkgs#cowsay -- "Hello"
```

## Permanent installation

Per-project:

1. Check the development shell configuration in `flake.nix`
2. Add the package
3. Reload the development shell

Globally:

1. Determine the OS configuration project:
   - macOS: `~/Documents/macos-setup`
   - NixOS: `~/Documents/nixos-setup`
2. Find the right nix file to add the package:
   - Explore the project structure (varies per project)
   - Common locations: `configuration.nix`, `default.nix`
   - Consider: system vs user package, stable vs unstable channel
   - If unsure where to add it, ask the user
3. Add the package to the appropriate packages list
4. Apply changes:
   - `make` in the OS configuration project directory
   - It may require sudo password or TouchID authentication from the user
