{
  config,
  pkgs,
  ...
}:

let
  username = config.primaryUser.username;
in

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
  ];

  primaryUser.username = "khuedoan";
  primaryUser.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6HOaBZDGKmTHMHekPwzbb6inFGFlBFNsm3y+/AaQ9S nix-builder-MacBookPro"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5qSejUhkUMiaFlShJdS9fuG5iRKVnmZStiQw6n3lez mbp-work"
  ];

  networking = {
    hostName = "codeserver";
    firewall.allowedTCPPorts = [ 4444 ];
  };

  microvm = {
    hypervisor = "qemu";
    mem = 3072;
    vcpu = 2;

    interfaces = [
      {
        type = "user";
        id = "codeserver";
        mac = "02:00:00:00:00:01";
      }
    ];

    forwardPorts = [
      {
        from = "host";
        host = {
          address = "127.0.0.1";
          port = 4444;
        };
        guest.port = 4444;
      }
    ];

    volumes = [
      {
        image = "codeserver-home.img";
        mountPoint = "/home";
        size = 8192;
      }
    ];
  };

  services.code-server = {
    enable = true;
    user = username;
    host = "0.0.0.0";
    port = 4444;
    auth = "none";
    disableUpdateCheck = true;
    disableTelemetry = true;
    disableWorkspaceTrust = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    createHome = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = config.primaryUser.authorizedKeys;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    tmux
  ];

  nix.settings.trusted-users = [
    "root"
    username
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username}.home.stateVersion = "26.05";
  };

  system.stateVersion = "26.05";
}
