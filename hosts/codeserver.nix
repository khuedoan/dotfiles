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

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  nix.settings.trusted-users = [
    "root"
    "khuedoan"
  ];

  environment.systemPackages = [ pkgs.unofficial.t3code ];

  services.nginx = {
    enable = true;
    virtualHosts.t3code = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 3772;
        }
      ];
      extraConfig = ''
        if ($http_tailscale_user_login != "khuedoan@github") {
          return 403;
        }
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:3773";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
        '';
      };
    };
  };

  users.users.${username}.linger = true;

  # To get token on first pair:
  # journalctl --user -u t3code -b --no-pager
  home-manager.users.${username}.systemd.user.services.t3code = {
    Unit = {
      Description = "T3 Code web server";
      Requires = [ "ssh-tpm-agent.socket" ];
      After = [ "ssh-tpm-agent.socket" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Environment = [
        "PATH=${lib.makeBinPath (lib.unique ([ "/run/wrappers" ] ++ profilePaths ++ [ "${home}/.local" ]))}"
        "SSH_AUTH_SOCK=%t/ssh-tpm-agent.sock"
      ];
      WorkingDirectory = home;
      ExecStart = "${pkgs.unofficial.t3code}/bin/t3 serve --host 127.0.0.1 --port 3773";
      Restart = "on-failure";
      RestartSec = 5;
      UMask = "0077";
    };
  };

  systemd.services.t3code-https = {
    description = "T3 Code HTTPS access over Tailscale";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "tailscaled.service"
      "nginx.service"
    ];
    after = [
      "tailscaled.service"
      "nginx.service"
    ];
    serviceConfig = {
      ExecStart = "${config.services.tailscale.package}/bin/tailscale serve --https=443 http://127.0.0.1:3772";
      Restart = "always";
      RestartSec = 5;
    };
  };

}
