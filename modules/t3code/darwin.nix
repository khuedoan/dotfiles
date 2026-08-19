{
  config,
  lib,
  pkgs,
  ...
}:

{
  home-manager.users.${config.primaryUser.username} =
    { config, ... }:
    {
      launchd.agents.t3code = {
        enable = true;
        config = {
          EnvironmentVariables = {
            # launchd has minimal PATH by default
            PATH =
              lib.replaceStrings
                [ "$HOME" "$USER" ]
                [
                  config.home.homeDirectory
                  config.home.username
                ]
                config.environment.systemPath;
          };
          KeepAlive = true;
          ProgramArguments = [
            (lib.getExe pkgs.unofficial.t3code)
            "serve"
            "--host"
            "0.0.0.0"
          ];
          RunAtLoad = true;
          WorkingDirectory = config.home.homeDirectory;
        };
      };
    };
}
