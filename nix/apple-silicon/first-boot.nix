{
  config,
  lib,
  pkgs,
  ...
}:

let
  contract = import ./contract.nix;
  firmwareDest = "/etc/nixos/${contract.firmwareRelativeDir}";
  registrationFile = "/nix-path-registration";
in
{
  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${lib.getExe' pkgs.e2fsprogs "tune2fs"}
  '';

  boot.initrd.postDeviceCommands = ''
    root_device=/dev/disk/by-label/${contract.rootLabel}
    image_uuid=${contract.rootImageUuid}
    if [ -b "$root_device" ]; then
      current_uuid=$(tune2fs -l "$root_device" | sed -n 's/^Filesystem UUID: *//p')
      if [ "$current_uuid" = "$image_uuid" ]; then
        tune2fs -U random "$root_device"
      fi
    fi
  '';

  systemd.services.register-nix-paths = {
    description = "Register Nix store paths from the installer image";
    unitConfig = {
      DefaultDependencies = false;
      ConditionPathExists = registrationFile;
    };
    wantedBy = [ "sysinit.target" ];
    before = [
      "sysinit.target"
      "shutdown.target"
      "nix-daemon.socket"
      "nix-daemon.service"
    ];
    after = [ "local-fs.target" ];
    conflicts = [ "shutdown.target" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${lib.getExe' config.nix.package.out "nix-store"} --load-db < ${registrationFile}
      touch /etc/NIXOS
      ${lib.getExe' config.nix.package.out "nix-env"} -p /nix/var/nix/profiles/system --set /run/current-system
      rm -f ${registrationFile}
    '';
  };

  systemd.services.expand-apple-silicon-root = {
    description = "Grow the NixOS root filesystem to the partition";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    before = [ "display-manager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [
      pkgs.e2fsprogs
      pkgs.util-linux
    ];
    script = ''
      root_device=$(findmnt -n -o SOURCE /)
      resize2fs "$root_device"
    '';
  };

  systemd.services.copy-apple-silicon-firmware = {
    description = "Copy Asahi firmware into the NixOS configuration tree";
    wantedBy = [ "multi-user.target" ];
    after = [
      "boot.mount"
      "local-fs.target"
    ];
    before = [ "display-manager.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${./copy-firmware.sh} /boot/asahi ${firmwareDest}
    '';
  };
}
