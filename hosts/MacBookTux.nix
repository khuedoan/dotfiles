{
  config,
  inputs,
  lib,
  ...
}:

let
  contract = import ../nix/apple-silicon/contract.nix;
  firmwareDirectory = ./MacBookTux/firmware;
in
{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/personal
    ../nix/apple-silicon/first-boot.nix
    inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
  ];

  primaryUser.username = "khuedoan";

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
      device = "/dev/disk/by-label/${contract.rootLabel}";
      fsType = "ext4";
    };

    "/boot" = {
      device = contract.espByLabel;
      fsType = "vfat";
      options = [
        "umask=0077"
      ];
    };
  };

  boot = {
    binfmt.emulatedSystems = lib.mkForce [ "x86_64-linux" ];
    initrd.prepend = lib.optionals config.hardware.asahi.extractPeripheralFirmware [
      "${firmwareDirectory}/firmware.cpio"
    ];

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
      enable = true;
      peripheralFirmwareDirectory = firmwareDirectory;
      extractPeripheralFirmware = builtins.pathExists (firmwareDirectory + "/firmware.cpio");
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
