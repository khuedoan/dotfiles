{
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.jovian.nixosModules.default
  ];

  hardware.graphics.enable32Bit = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-jupiter-unwrapped"
      "steam-unwrapped"
      "steamdeck-hw-theme"
    ];

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = config.primaryUser.username;
    desktopSession = "gamescope-wayland";
  };
}
