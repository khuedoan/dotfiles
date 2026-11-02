{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.primaryUser.username;
  home = config.users.users.${username}.home;
  profilePaths = map (lib.replaceStrings
    [ "$HOME" "$USER" "\${XDG_STATE_HOME}" ]
    [
      home
      username
      config.home-manager.users.${username}.xdg.stateHome
    ]
  ) config.environment.profiles;
  hermesServiceConfig = {
    User = username;
    WorkingDirectory = "${home}/Projects";
    Environment = [
      "PYTHONUNBUFFERED=1"
      "XDG_DATA_DIRS=/run/current-system/sw/share"
      "PATH=${lib.makeBinPath (lib.unique ([ "/run/wrappers" ] ++ profilePaths ++ [ "${home}/.local" ]))}"
    ];
    Restart = "always";
    RestartSec = 5;
  };
in
{
  systemd.services.signal-cli = {
    description = "signal-cli Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = username;
      WorkingDirectory = home;
      Environment = [ "HOME=${home}" ];
      ExecStart = "${pkgs.signal-cli}/bin/signal-cli -a +84812942437 daemon --http 127.0.0.1:8080";

      Restart = "always";
      RestartSec = "5";
    };
  };

  systemd.services.hermes-gateway = {
    description = "Hermes Agent Gateway";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network-online.target"
      "signal-cli.service"
    ];
    wants = [
      "network-online.target"
      "signal-cli.service"
    ];

    unitConfig.StartLimitIntervalSec = "0";

    serviceConfig = hermesServiceConfig // {
      ExecStart = "${pkgs.unofficial.hermes-agent}/bin/hermes gateway run";
      TimeoutStopSec = "90";
    };
  };

  systemd.services.hermes-dashboard = {
    description = "Hermes Agent Web Dashboard";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = hermesServiceConfig // {
      ExecStart = "${pkgs.unofficial.hermes-agent}/bin/hermes dashboard --host 127.0.0.1 --no-open";
      Environment = hermesServiceConfig.Environment ++ [
        "HERMES_DASHBOARD_PUBLIC_URL=https://codeserver.leo-bortle.ts.net:9119"
      ];
    };
  };

  systemd.services.hermes-https = {
    description = "Hermes HTTPS access over Tailscale";
    wantedBy = [ "multi-user.target" ];
    wants = [ "tailscaled.service" ];
    after = [ "tailscaled.service" ];
    serviceConfig = {
      ExecStart = "${config.services.tailscale.package}/bin/tailscale serve --https=9119 http://127.0.0.1:9119";
      Restart = "always";
      RestartSec = 5;
    };
  };

  programs.xfconf.enable = true;

  fonts.packages = [ pkgs.dejavu_fonts ];

  environment.pathsToLink = [
    "/share/xfce4"
    "/lib/xfce4"
  ];

  environment.systemPackages = [
    pkgs.brave
    pkgs.unofficial.hermes-agent
    pkgs.signal-cli
    pkgs.tigervnc
    pkgs.xfwm4
    pkgs.xfce4-panel
    pkgs.xfdesktop
    pkgs.xfce4-settings
    pkgs.xfce4-terminal
    pkgs.xauth
    pkgs.xdpyinfo
    pkgs.setxkbmap
    pkgs.xprop
    pkgs.xset
    pkgs.xsetroot
  ];
}
