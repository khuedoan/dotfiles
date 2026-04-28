{ ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/personal
  ];

  primaryUser.username = "khuedoan";

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  networking = {
    hostName = "codeserver";
  };

  services.code-server = {
    enable = true;
    host = "0.0.0.0";
    user = "khuedoan";
    disableUpdateCheck = true;
    disableTelemetry = true;
    disableWorkspaceTrust = true;
    # See also ~/.config/code-server/config.yaml
  };
}
