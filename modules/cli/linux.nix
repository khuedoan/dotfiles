{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    file
    gcc
    gnumake
    killall
    python3
  ];

  programs = {
    gnupg.agent.enable = true;
  };

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs.unstable; [
    # AI sandboxing
    bubblewrap
    socat
  ];
}
