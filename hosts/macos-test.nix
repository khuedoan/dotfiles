{ lib, ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
  ];

  primaryUser.username = "runner";
  primaryUser.authorizedKeys = [ ];

  networking.hostName = "macos-test";

  # TODO Linux builder is disabled in CI until bootstrap issues are fixed.
  nix.linux-builder.enable = lib.mkForce false;
}
