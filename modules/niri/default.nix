{ platform, ... }:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];
}
