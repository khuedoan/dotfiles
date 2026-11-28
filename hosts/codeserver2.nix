{
  config,
  lib,
  ...
}:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/personal
    ../modules/t3code
  ];

  primaryUser.username = "khuedoan";
  nixpkgs.hostPlatform = "aarch64-linux";

  # This is the OCI boot disk slot. The attached data volume uses SCSI target 1.
  disko.devices.disk.main.device = "/dev/disk/by-path/pci-0000:18:00.0-scsi-0:0:0:1";

  boot = {
    binfmt.emulatedSystems = lib.mkForce [ ];
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
    ];
    kernelParams = [ "console=ttyAMA0" ];
  };

  services.openssh.settings.KbdInteractiveAuthentication = false;

  system.autoUpgrade = {
    enable = true;
    flake = "github:khuedoan/dotfiles/master#codeserver2";
    flags = [ "--accept-flake-config" ];
    dates = "04:40";
    upgrade = false;
    allowReboot = true;
  };

  nix.settings.trusted-users = [
    "root"
    config.primaryUser.username
  ];
}
