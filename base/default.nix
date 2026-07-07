{
  lib,
  pkgs,
  platform,
  ...
}:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  options.primaryUser = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Local account username for this host.";
    };
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys authorized for the primary user on this host.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      curl
      git
      jujutsu
      tmux
      tree
      unzip
      watch
    ];

    programs = {
      zsh.enable = true;
      direnv = {
        enable = true;
        silent = true;
      };
    };

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
