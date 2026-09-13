{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  installer.cloneConfig = false;

  users.users.root.openssh.authorizedKeys.keys = [
    # I'm too lazy to generate a separate key for the installer,
    # just use the existing hardware keys, it's secure enough.
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG ryzentower"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6HOaBZDGKmTHMHekPwzbb6inFGFlBFNsm3y+/AaQ9S nix-builder-MacBookPro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5qSejUhkUMiaFlShJdS9fuG5iRKVnmZStiQw6n3lez mbp-work"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM/WQcPFuzsPmfXSM1GGkIndFcDRirTl5Aqsou8lWPJyUNZOdFt2cWlUkm+Q1F+LFJQ2+YdIXPZlTqhWLF1eWuY= khuedoan@codeserver"
  ];

  system.stateVersion = "25.05";
}
