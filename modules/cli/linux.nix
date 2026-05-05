{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    file
    gcc
    gnumake
    killall
    python3
  ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
