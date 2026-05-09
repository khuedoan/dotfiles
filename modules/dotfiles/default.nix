{
  config,
  lib,
  pkgs,
  ...
}:

let
  dotfiles = lib.mapAttrs' (
    name: type:
    lib.nameValuePair name {
      source = ./home + "/${name}";
      recursive = type == "directory";
    }
  ) (builtins.readDir ./home);
in
{
  config.home-manager.users.${config.primaryUser.username} = {
    home.file = dotfiles // {
      "Pictures/Wallpapers/astronaut-jellyfish.jpg".source = builtins.fetchurl {
        url = "https://github.com/user-attachments/assets/b63195d0-7fe3-4ab5-95c7-20127123836c";
        sha256 = "1g120j4z6665j4wh2g84m4rb24gvzdxyhx9lqym68cwn8ny2j7fz";
      };
    };
  };
}
