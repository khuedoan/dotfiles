{ ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/personal
  ];

  primaryUser.username = "khuedoan";
  primaryUser.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6HOaBZDGKmTHMHekPwzbb6inFGFlBFNsm3y+/AaQ9S nix-builder-MacBookPro"
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  nix.settings.trusted-users = [
    "root"
    "khuedoan"
  ];

  networking = {
    hostName = "codeserver";
  };
}
