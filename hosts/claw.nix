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
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/personal
  ];

  # Explicit disk for nixos-anywhere
  disko.devices.disk.main.device = "/dev/sda";

  primaryUser.username = "khuedoan";

  # TODO manual setup
  # hermes model
  # hermes gateway setup
  # hermes config set dashboard.basic_auth.username admin
  # Set HERMES_DASHBOARD_BASIC_AUTH_PASSWORD in ~/.hermes/.env
  systemd.services.hermes-gateway = {
    description = "Hermes Agent Gateway";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      User = "khuedoan";
      WorkingDirectory = "/home/khuedoan/Projects";
      ExecStart = "${pkgs.unofficial.hermes-agent}/bin/hermes gateway run";
      Environment = [
        "PYTHONUNBUFFERED=1"
        "PATH=${lib.makeBinPath (lib.unique ([ "/run/wrappers" ] ++ profilePaths ++ [ "${home}/.local" ]))}"
        "SSH_AUTH_SOCK=%t/ssh-tpm-agent.sock"
      ];

      Restart = "always";
      RestartSec = "5";
      TimeoutStopSec = "90";
      StartLimitIntervalSec = "0";
    };
  };

  systemd.services.hermes-dashboard = {
    description = "Hermes Agent Web Dashboard";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "khuedoan";
      WorkingDirectory = "/home/khuedoan/Projects";
      ExecStart = "${pkgs.unofficial.hermes-agent}/bin/hermes dashboard --host 0.0.0.0 --no-open";
      Environment = [ "PYTHONUNBUFFERED=1" ];

      Restart = "always";
      RestartSec = "5";
    };
  };

  environment.systemPackages = [
    pkgs.unofficial.hermes-agent
  ];
}
