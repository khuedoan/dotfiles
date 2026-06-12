{
  config,
  lib,
  pkgs,
  ...
}:

let
  firmwareDirectory = ./MacBookTux/firmware;
in
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

  networking = {
    hostName = "MacBookTux";
    networkmanager.wifi.backend = "iwd";
  };

  nixpkgs = {
    hostPlatform = "aarch64-linux";
  };

  nix = {
    settings = {
      extra-substituters = [
        "https://nixos-apple-silicon.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      ];
    };
  };

  disko.devices = lib.mkForce { };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/EFI\\x20-\\x20NIXOS";
      fsType = "vfat";
      options = [
        "umask=0077"
      ];
    };
  };

  boot = {
    binfmt.emulatedSystems = lib.mkForce [ "x86_64-linux" ];

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = false;
    };

    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = firmwareDirectory;
      extractPeripheralFirmware = builtins.pathExists (firmwareDirectory + "/all_firmware.tar.gz");
    };
  };

  services = {
    kanata.enable = false;
  };

  home-manager.users.${config.primaryUser.username}.home.file.".config/sway/config.d/hardware".text =
    ''
      output "eDP-1" {
        scale 2
      }
    '';
}
