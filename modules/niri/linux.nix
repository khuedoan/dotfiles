{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec niri-session -l
    fi
  '';

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    jq
    pkgs.unstable.noctalia
    procps
    soteria
    wl-clipboard
  ];

  home-manager.users.${config.primaryUser.username} = {
    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    home.file.".config/niri/config.d/hardware.kdl".text = lib.mkDefault "";
  };
}
