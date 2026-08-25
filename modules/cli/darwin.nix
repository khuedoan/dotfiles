{ config, pkgs, ... }:

{
  homebrew = {
    # TODO use mcporter when nixpkgs#553055 is merged
    taps = [ "steipete/tap" ];
    brews = [ "steipete/tap/mcporter" ];
  };

  environment.systemPackages = with pkgs; [
    colima
    coreutils
    docker
    gnupg
    mosh
    pinentry-tty
  ];

  environment.systemPath = [
    "${config.homebrew.prefix}/bin"
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enableBashCompletion = false;
      enableCompletion = false;
      promptInit = "";
    };
  };
}
