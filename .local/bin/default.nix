#!/usr/bin/env nix-shell

# TODO rename to .local/bin/tools

# https://status.nixos.org
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/e0ed589d7422.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    brave
  ];
}
