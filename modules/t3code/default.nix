{
  pkgs,
  platform,
  ...
}:

{
  imports = [ ./${platform.parsed.kernel.name}.nix ];

  environment.systemPackages = [ pkgs.unofficial.t3code ];
}
