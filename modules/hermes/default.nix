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

    serviceConfig = {
      User = username;
      WorkingDirectory = "${home}/Projects";
      ExecStart = "${pkgs.unofficial.hermes-agent}/bin/hermes gateway run";
      Environment = [
        "PYTHONUNBUFFERED=1"
        "PATH=${lib.makeBinPath (lib.unique ([ "/run/wrappers" ] ++ profilePaths ++ [ "${home}/.local" ]))}"
      ];

      Restart = "always";
      RestartSec = "5";
      TimeoutStopSec = "90";
    };
  };

  systemd.services.hermes-dashboard = {
    description = "Hermes Agent Web Dashboard";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = username;
      WorkingDirectory = "${home}/Projects";
      ExecStart = "${pkgs.unofficial.hermes-agent}/bin/hermes dashboard --host 127.0.0.1 --no-open";
      Environment = [ "PYTHONUNBUFFERED=1" ];

      Restart = "always";
      RestartSec = "5";
    };
  };

  environment.systemPackages = [
    pkgs.brave
    pkgs.unofficial.hermes-agent
    pkgs.signal-cli
  ];

}
