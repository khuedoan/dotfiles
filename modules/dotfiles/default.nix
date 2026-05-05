{ config, pkgs, ... }:

{
  config.home-manager.users.${config.primaryUser.username} = {
    home.file."Pictures/Wallpapers/astronaut-jellyfish.jpg".source = builtins.fetchurl {
      url = "https://github.com/user-attachments/assets/b63195d0-7fe3-4ab5-95c7-20127123836c";
      sha256 = "1g120j4z6665j4wh2g84m4rb24gvzdxyhx9lqym68cwn8ny2j7fz";
    };

    home.activation.dotfiles = ''
      set -eu

      if [ ! -d "$HOME/.git" ]; then
        ${pkgs.git}/bin/git init
        ${pkgs.git}/bin/git config status.showUntrackedFiles no
        ${pkgs.git}/bin/git remote add origin https://github.com/khuedoan/dotfiles

        until ${pkgs.curl}/bin/curl --fail --silent --head --output /dev/null https://github.com; do
          sleep 1
        done

        ${pkgs.git}/bin/git pull origin master
        ${pkgs.git}/bin/git branch --set-upstream-to=origin/master master
      fi
    '';
  };
}
