{ config, pkgs, ... }:

{
  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec sway
    fi
  '';

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      autotiling
      grim
      pkgs.unstable.noctalia
      slurp
      soteria
      wl-clipboard
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  home-manager.users.${config.primaryUser.username}.gtk = {
    enable = true;
    colorScheme = "dark";
  };
}
