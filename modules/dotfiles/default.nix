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
        "Pictures/Wallpapers/astronaut-jellyfish.jpg".source = builtins.fetchurl {
          url = "https://github.com/user-attachments/assets/b63195d0-7fe3-4ab5-95c7-20127123836c";
          sha256 = "1g120j4z6665j4wh2g84m4rb24gvzdxyhx9lqym68cwn8ny2j7fz";
        };
      };
    };
}
