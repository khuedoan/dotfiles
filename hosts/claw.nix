{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/personal
  ];

  # Explicit disk for nixos-anywhere
  disko.devices.disk.main.device = "/dev/sda";

  primaryUser.username = "khuedoan";
}
