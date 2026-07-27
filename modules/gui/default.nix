{ config, pkgs, platform, ... }:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  home-manager.users.${config.primaryUser.username} =
    { config, ... }:
    {
      services.git-sync = {
        enable = true;
        repositories.notes = {
          path = "${config.home.homeDirectory}/Projects/notes";
          uri = "git@github.com:khuedoan/notes.git";
          interval = 300;
        };
      };
    };
}
