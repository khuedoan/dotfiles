{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/personal
  ];

  primaryUser.username = "khuedoan";
  primaryUser.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s="
  ];

  hardware = {
    graphics = {
      enable32Bit = true;
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      rocmSupport = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-unwrapped"
        ];
    };
  };

  programs = {
    steam = {
      enable = true;
    };
  };

  home-manager.users.${config.primaryUser.username} = {
    home = {
      file.".config/sway/config.d/hardware".text = ''
        output "DP-3" {
          mode 2560x1440@180Hz
        }
        output "HDMI-A-1" {
          scale 2
        }
      '';
      packages = with pkgs.unstable; [
        me3 # For Elden Ring mod
      ];
    };
  };
}
