{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  installer.cloneConfig = false;

  users.users.root.openssh.authorizedKeys.keys = import ../base/authorized-keys.nix;

  system.stateVersion = "25.05";
}
