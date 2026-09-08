{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/personal
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

}
