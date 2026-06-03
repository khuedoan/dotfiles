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
}
