{
  releaseId = builtins.replaceStrings [ "\n" "\r" ] [ "" "" ] (builtins.readFile ./release-id);
  rootLabel = "nixos";
  rootImageUuid = "44444444-4444-4444-8888-888888888888";
  espLabel = "EFI - NIXOS";
  espByLabel = "/dev/disk/by-label/EFI\\x20-\\x20NIXOS";
  osListName = "NixOS (MacBookTux)";
  defaultOsName = "NIXOS";
  packageName = "MacBookTux.zip";
  installerVersion = "v0.9.1";
  installerHash = "sha256-vFu8qdTFfN86QYxStrQCqErm23dt1a1VZA/bXRGe5LA=";
  supportedFw = [ "13.5" ];
  espSize = "1GB";
  volumeId = "0x4e49584f";
  firmwareRelativeDir = "hosts/MacBookTux/firmware";
}
