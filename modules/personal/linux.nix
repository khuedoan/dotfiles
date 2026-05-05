{ config, pkgs, ... }:

let
  username = config.primaryUser.username;
in

{
  home-manager.users.${username} = {
    home.packages = with pkgs.unstable; [
      signal-desktop
    ];

    systemd.user = {
      services.sync-notes = {
        Unit.Description = "Sync notes";
        Service = {
          Type = "oneshot";
          WorkingDirectory = "%h/Documents/notes";
          Environment = [
            "HOSTNAME=%H"
            "GIT_SSH_COMMAND=/run/current-system/sw/bin/ssh"
          ];
          ExecStart = "${pkgs.writeTextFile {
            name = "sync-notes";
            executable = true;
            text = ''
              #!${pkgs.bash}/bin/sh
              set -eu

              if [ -n "$(${pkgs.git}/bin/git status --porcelain)" ]; then
                ${pkgs.git}/bin/git add --all
                if ! ${pkgs.git}/bin/git diff --cached --quiet; then
                  ${pkgs.git}/bin/git commit -m "Update notes from $HOSTNAME"
                fi
              fi
              ${pkgs.git}/bin/git pull --rebase --strategy-option theirs
              ${pkgs.git}/bin/git push
            '';
          }}";
        };
      };
      timers.sync-notes = {
        Unit.Description = "Sync notes every 5 minutes";
        Timer = {
          OnUnitActiveSec = "5min";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
