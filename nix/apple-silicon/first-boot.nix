{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  contract = import ./contract.nix;
  rootDevice = "/dev/disk/by-label/${contract.rootLabel}";
  rootDeviceUnit = "${utils.escapeSystemdPath rootDevice}.device";
  firmwareSource = "/boot/vendorfw";
  firmwareDest = "/etc/nixos/${contract.firmwareRelativeDir}";
  firmwareRuntime = "/run/asahi-firmware";
  registrationFile = "/nix-path-registration";
in
{
  boot.kernelParams = [ "firmware_class.path=/vendorfw" ];

  boot.initrd.systemd = {
    initrdBin = [ pkgs.e2fsprogs ];
    services."randomize-apple-silicon-root-uuid" = {
      description = "Randomize the UUID of the installed root filesystem";
      requires = [ rootDeviceUnit ];
      requiredBy = [ "sysroot.mount" ];
      after = [ rootDeviceUnit ];
      before = [
        "systemd-fsck@${utils.escapeSystemdPath rootDevice}.service"
        "sysroot.mount"
      ];
      unitConfig = {
        DefaultDependencies = false;
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        image_uuid=${contract.rootImageUuid}
        current_info=$(tune2fs -l ${rootDevice})
        current_uuid=$(printf '%s\n' "$current_info" | sed -n 's/^Filesystem UUID: *//p')
        if [ "$current_uuid" = "$image_uuid" ]; then
          tune2fs -U random ${rootDevice}
        fi
      '';
    };

    services.preserve-apple-silicon-firmware = {
      description = "Keep Asahi firmware available after switch-root";
      requiredBy = [ "initrd-switch-root.service" ];
      after = [
        "sysroot.mount"
        "sysroot-run.mount"
      ];
      before = [
        "initrd-nixos-activation.service"
        "initrd-switch-root.service"
      ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p ${firmwareRuntime} /lib/firmware /sysroot/lib/firmware
        cp -a /vendorfw/. ${firmwareRuntime}/
        ln -sfn ${firmwareRuntime} /lib/firmware/vendor
        ln -sfn ${firmwareRuntime} /sysroot/lib/firmware/vendor
      '';
    };
  };

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
    unitConfig.RequiresMountsFor = [ "/boot" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${./copy-firmware.sh} ${firmwareSource} ${firmwareDest}
    '';
  };
}
