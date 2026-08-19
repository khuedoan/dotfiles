{
  config,
  lib,
  pkgs,
  ...
}:

let
  username = config.primaryUser.username;
  home = config.users.users.${username}.home;
in
{
  systemd.services.t3code = {
    description = "T3 Code server";
    wantedBy = [ "multi-user.target" ];
    environment.HOME = home;
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.unstable.t3code} serve --host 0.0.0.0";
      Restart = "always";
      RestartSec = 5;
      User = username;
      WorkingDirectory = home;
    };
  };
}
