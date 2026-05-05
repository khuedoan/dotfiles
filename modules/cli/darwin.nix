{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coreutils
    docker
    gnupg
    pinentry-tty
  ];

  homebrew.casks = [
    "claude-code"
  ];

  environment.systemPath = [
    config.homebrew.brewPrefix # TODO https://github.com/LnL7/nix-darwin/issues/596
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = false;
      enableCompletion = false;
      promptInit = "";
    };
    direnv = {
      # TODO remove this workaround https://github.com/NixOS/nixpkgs/issues/507531
      package = pkgs.direnv.overrideAttrs (_: {
        doCheck = false;
      });
      silent = true;
    };
  };
}
