{ ... }:

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
