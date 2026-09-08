{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  installer.cloneConfig = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [
    # I'm too lazy to generate a separate key for the installer,
    # just use the existing hardware keys, it's secure enough.
    ../modules/dotfiles/home/.ssh/authorized_keys
  ];

  system.stateVersion = "25.05";
}
