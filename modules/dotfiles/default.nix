{
  config,
  lib,
  ...
}:

let
  username = config.primaryUser.username;
  sourceRoot = ./home;

  relativeFiles = map (lib.path.removePrefix sourceRoot) (
    lib.filesystem.listFilesRecursive sourceRoot
  );
in
{
  config.home-manager.users.${username} =
    { config, ... }:

    let
      checkoutRoot = "${config.home.homeDirectory}/Projects/dotfiles/modules/dotfiles/home";

      dotfiles = lib.genAttrs relativeFiles (relativePath: {
        # This improves iteration speed but provides fewer Nix guarantees.
        source = config.lib.file.mkOutOfStoreSymlink "${checkoutRoot}/${relativePath}";
      });
    in
    {
      home.file = dotfiles // {
        ".ssh/authorized_keys".text = ''
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG ryzentower
          ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E=
          ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s=
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6HOaBZDGKmTHMHekPwzbb6inFGFlBFNsm3y+/AaQ9S nix-builder-MacBookPro
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5qSejUhkUMiaFlShJdS9fuG5iRKVnmZStiQw6n3lez mbp-work
          ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM/WQcPFuzsPmfXSM1GGkIndFcDRirTl5Aqsou8lWPJyUNZOdFt2cWlUkm+Q1F+LFJQ2+YdIXPZlTqhWLF1eWuY= khuedoan@codeserver
        '';
        "Pictures/Wallpapers/astronaut-jellyfish.jpg".source = builtins.fetchurl {
          url = "https://github.com/user-attachments/assets/b63195d0-7fe3-4ab5-95c7-20127123836c";
          sha256 = "1g120j4z6665j4wh2g84m4rb24gvzdxyhx9lqym68cwn8ny2j7fz";
        };
      };
    };
}
