{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coreutils
    docker
    gnupg
    pinentry-tty
  ];

  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = false;
      enableCompletion = false;
      promptInit = "";
    };
  };
}
