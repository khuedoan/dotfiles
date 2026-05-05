{ pkgs, platform, ... }:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
}
