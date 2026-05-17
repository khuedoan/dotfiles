{ config, lib, ... }:

let
  username = config.primaryUser.username;
in

{
  system.primaryUser = username;

  # TODO https://github.com/LnL7/nix-darwin/issues/682
  users.users.${username}.home = "/Users/${username}";

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
  };

  services = {
    # TODO some machine have the driver blocked, needs to install from the web
    # And Karabiner on nix-darwin is currently broken https://github.com/LnL7/nix-darwin/issues/1041
    # karabiner-elements.enable = true;
    tailscale.enable = true;
  };

  nix = {
    # configureBuildUsers = true;
    settings = {
      allowed-users = [
        "@admin"
      ];
      trusted-users = [
        "@admin"
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.users.${username} = {
    home.stateVersion = lib.mkDefault "25.05";
    programs.home-manager.enable = lib.mkDefault true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
