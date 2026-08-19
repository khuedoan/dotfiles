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
  launchd.daemons.t3code.serviceConfig = {
    EnvironmentVariables.HOME = home;
    KeepAlive = true;
    ProgramArguments = [
      (lib.getExe pkgs.unofficial.t3code)
      "serve"
      "--host"
      "0.0.0.0"
    ];
    RunAtLoad = true;
    UserName = username;
    WorkingDirectory = home;
  };
}
