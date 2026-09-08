{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/personal
    ../modules/steam-machine
  ];

  primaryUser.username = "khuedoan";

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.rocmSupport = true;
  };

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs.unstable; [
    me3 # For Elden Ring mod
  ];
}
