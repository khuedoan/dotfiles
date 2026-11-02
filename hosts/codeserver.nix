{ config, ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/hermes
    ../modules/personal
    ../modules/t3code
  ];

  # Explicit disk for nixos-anywhere
  disko.devices.disk.main.device = "/dev/sda";

  primaryUser.username = "khuedoan";

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  nix.settings.trusted-users = [
    "root"
    "khuedoan"
  ];

  security.sudo.extraRules = [
    # TODO I'm too lazy to enter password for Nixie every time so I'm YOLOing a bit here,
    # maybe there's a better way to make Nixie requires less root level permissions?
    {
      users = [ config.primaryUser.username ];
      runAs = "root";
      commands = [
        {
          command = "/nix/store/*-nixie-*/bin/nixie";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  networking = {
    firewall = {
      allowedTCPPorts = [
        80 # iPXE boot files
        5000 # Nixie agent API
      ];
      allowedUDPPorts = [
        67 # ProxyDHCP
        69 # TFTP
        4011 # UEFI PXE
      ];
    };
  };
}
