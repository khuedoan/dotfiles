{ pkgs }:

let
  firmwareArchive =
    pkgs.runCommand "test-asahi-firmware.cpio" { nativeBuildInputs = [ pkgs.cpio ]; }
      ''
        mkdir -p vendorfw/brcm
        printf 'Asahi test firmware\n' > vendorfw/brcm/test.bin
        find vendorfw | cpio -o -H newc > $out
      '';
  rootDisk =
    pkgs.runCommand "test-asahi-root.qcow2"
      {
        nativeBuildInputs = [
          pkgs.e2fsprogs
          pkgs.qemu_test
        ];
      }
      ''
        truncate -s 512M root.img
        mkfs.ext4 -b 4096 -L nixos -U 44444444-4444-4444-8888-888888888888 root.img 32768
        qemu-img convert -f raw -O qcow2 root.img $out
      '';
in
pkgs.testers.runNixOSTest {
  name = "apple-silicon-first-boot";

  nodes.machine = {
    imports = [ ../nix/apple-silicon/first-boot.nix ];
    virtualisation.diskImage = "./machine.qcow2";
    boot.initrd = {
      systemd.enable = true;
      prepend = [ "${firmwareArchive}" ];
    };
    systemd.tmpfiles.rules = [
      "d /boot/vendorfw 0755 root root -"
      "C /boot/vendorfw/firmware.cpio 0644 root root - ${firmwareArchive}"
    ];
  };

  testScript = ''
    import shutil

    shutil.copyfile("${rootDisk}", machine.state_dir / "machine.qcow2")
    for boot in range(2):
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.wait_for_unit("copy-apple-silicon-firmware.service")
        machine.wait_for_unit("expand-apple-silicon-root.service")
        size = machine.succeed("df -B1 --output=size / | tail -n 1")
        assert int(size) > 256 * 1024 * 1024
        machine.succeed("test ! -d /vendorfw")
        assert machine.succeed("cat /lib/firmware/vendor/brcm/test.bin") == "Asahi test firmware\n"
        machine.succeed("cmp /boot/vendorfw/firmware.cpio /etc/nixos/hosts/MacBookTux/firmware/firmware.cpio")
        uuid = machine.succeed("blkid -s UUID -o value /dev/disk/by-label/nixos").strip()
        assert uuid != "44444444-4444-4444-8888-888888888888"
        if boot == 0:
            original_uuid = uuid
        else:
            assert uuid == original_uuid
        machine.shutdown()
  '';
}
