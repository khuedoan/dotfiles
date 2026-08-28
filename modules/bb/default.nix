{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.primaryUser.username;
  homeDirectory = config.users.users.${username}.home;
  bb = pkgs.unofficial.bb-app;
in

{
  home-manager.users.${username}.home.packages = [ bb ];

  systemd.services = {
    bb = {
      description = "bb agentic IDE";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      path = [
        config.home-manager.users.${username}.home.path
        config.system.path
        "${homeDirectory}/.local"
      ];

      environment = {
        HOME = homeDirectory;
        BB_TELEMETRY = "false";
      };

      serviceConfig = {
        Type = "simple";
        User = username;
        WorkingDirectory = homeDirectory;
        ExecStart = "${lib.getExe bb} --data-dir ${homeDirectory}/.bb --server-bind-host 127.0.0.1 start";
        Restart = "on-failure";
        RestartSec = "5s";
        UMask = "0077";
      };
    };

    bb-tailscale-serve = {
      description = "Expose bb to the tailnet";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "bb.service"
        "tailscaled.service"
      ];
      after = [
        "bb.service"
        "tailscaled.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.tailscale} serve --bg --yes http://127.0.0.1:38886";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
