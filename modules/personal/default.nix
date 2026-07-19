{ config, platform, ... }:

let
  username = config.primaryUser.username;
in

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  home-manager.users.${username} =
    { config, ... }:
    {
      services.git-sync = {
        enable = true;
        repositories.notes = {
          path = "${config.home.homeDirectory}/Projects/notes";
          uri = "gh:khuedoan/notes.git";
          interval = 300;
        };
      };
    };
}
