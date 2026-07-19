{ config, pkgs, ... }:

let
  username = config.primaryUser.username;
in

{
  home-manager.users.${username}.home.packages = with pkgs.unstable; [
    signal-desktop
  ];
}
