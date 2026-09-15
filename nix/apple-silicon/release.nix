{
  config,
  pkgs,
  repoRevision,
  self,
}:

let
  inherit (pkgs) lib;
  contract = import ./contract.nix;
  installer = pkgs.fetchurl {
    url = "https://cdn.asahilinux.org/installer/installer-${contract.installerVersion}.tar.gz";
    hash = contract.installerHash;
  };
  rootImage = pkgs.callPackage (pkgs.path + "/nixos/lib/make-ext4-fs.nix") {
    storePaths = [ config.system.build.toplevel ];
    compressImage = false;
    populateImageCommands = ''
      mkdir -p ./files/etc/nixos
      cp -a ${self}/. ./files/etc/nixos/
    '';
    volumeLabel = contract.rootLabel;
    uuid = contract.rootImageUuid;
  };
  kernelParams = lib.concatStringsSep " " (
    [ "init=${config.system.build.toplevel}/init" ] ++ config.boot.kernelParams
  );
  loaderEntry = pkgs.writeText "nixos.conf" ''
    title NixOS
    linux /EFI/nixos/Image
    initrd /EFI/nixos/initrd
    options ${kernelParams}
  '';
  loaderConfig = pkgs.writeText "loader.conf" ''
    default nixos.conf
    timeout ${toString config.boot.loader.timeout}
    editor ${if config.boot.loader.systemd-boot.editor then "yes" else "no"}
  '';
  installerData = {
    os_list = [
      {
        name = contract.osListName;
        default_os_name = contract.defaultOsName;
        boot_object = "m1n1.bin";
        next_object = "m1n1/boot.bin";
        package = contract.packageName;
        supported_fw = contract.supportedFw;
        partitions = [
          {
            name = "EFI";
            type = "EFI";
            size = contract.espSize;
            format = "fat";
            volume_id = contract.volumeId;
            copy_firmware = true;
            copy_installer_data = true;
            source = "esp";
          }
          {
            name = "Root";
            type = "Linux";
            size = "0B";
            expand = true;
            image = "root.img";
          }
        ];
      }
    ];
  };
  installerDataFile = pkgs.writeText "installer_data.json" (builtins.toJSON installerData);
in
pkgs.runCommand "apple-silicon-installer-release-${contract.releaseId}"
  {
    nativeBuildInputs = [
      pkgs.jq
      pkgs.zip
    ];
  }
  ''
    mkdir -p $out payload/esp/EFI/BOOT payload/esp/EFI/nixos payload/esp/loader/entries payload/esp/m1n1

    cp ${config.system.build.m1n1} payload/esp/m1n1/boot.bin
    cp ${config.systemd.package}/lib/systemd/boot/efi/systemd-bootaa64.efi payload/esp/EFI/BOOT/BOOTAA64.EFI
    cp ${config.system.build.kernel}/${config.system.boot.loader.kernelFile} payload/esp/EFI/nixos/Image
    cp ${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile} payload/esp/EFI/nixos/initrd
    cp ${loaderConfig} payload/esp/loader/loader.conf
    cp ${loaderEntry} payload/esp/loader/entries/nixos.conf
    cp ${rootImage} payload/root.img

    root_size=$(stat -c %s payload/root.img)
    if [ $((root_size % 4096)) -ne 0 ]; then
      echo "root.img is not aligned to 4096 bytes" >&2
      exit 1
    fi

    jq --arg size "''${root_size}B" \
      '.os_list[0].partitions[] |= if .image == "root.img" then .size = $size else . end' \
      ${installerDataFile} > $out/installer_data.json

    (cd payload && zip -0 -q -r $out/${contract.packageName} esp root.img)
    cp ${installer} $out/installer-${contract.installerVersion}.tar.gz

    cat > $out/manifest.tsv <<EOF
    schema	1
    release_id	${contract.releaseId}
    repo_revision	${repoRevision}
    installer_version	${contract.installerVersion}
    installer_sha256	$(sha256sum $out/installer-${contract.installerVersion}.tar.gz | cut -d ' ' -f 1)
    metadata_sha256	$(sha256sum $out/installer_data.json | cut -d ' ' -f 1)
    package_sha256	$(sha256sum $out/${contract.packageName} | cut -d ' ' -f 1)
    EOF
  ''
