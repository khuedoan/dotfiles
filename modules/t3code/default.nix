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
  networking.firewall.extraInputRules = ''
    ip saddr { 10.0.0.0/8, 100.64.0.0/10, 172.16.0.0/12, 192.168.0.0/16 } tcp dport 3773 accept
    ip6 saddr { fc00::/7, fe80::/10 } tcp dport 3773 accept
  '';

  environment.systemPackages = [ pkgs.unofficial.t3code ];

  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    at-spi2-core
    dbus
    expat
    glib
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
  ];

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
      ExecStart = "${pkgs.unofficial.t3code}/bin/t3 serve --host :: --port 3773";
      Restart = "on-failure";
      RestartSec = 5;
      UMask = "0077";
    };
  };
}
