{ config, ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/personal
  ];

  primaryUser.username = "khuedoan";
  primaryUser.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s="
  ];

  hardware = {
    graphics = {
      enable32Bit = true;
    };
  };

  security = {
    tpm2 = {
      # Extra setup steps https://nixos.wiki/wiki/TPM#Using_a_TPM2_with_OpenSSH
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      rocmSupport = true;
    };
  };

  networking = {
    hostName = "thinkpadz13";
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_DRIVER_OPMODE_ON_BAT = "active";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        START_CHARGE_THRESH_BAT0 = 30;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    kanata = {
      enable = true;
      keyboards = {
        builtin = {
          devices = [
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          ];
          config = ''
            (defalias
              xcp (tap-hold-press 10 200 esc lctl)
              fn  (layer-toggle function)
            )

            (defsrc
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rctl
            )

            (deflayer default
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              @xcp _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    lalt lmet           _              @fn  _
            )

            (deflayer function
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    lft  down up   rght _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _              _              _    _
            )
          '';
        };
      };
    };
  };

  home-manager.users.${config.primaryUser.username}.home.file.".config/sway/config.d/hardware".text = ''
    output "eDP-1" {
      scale 1.333
    }

    bindswitch --reload --locked lid:on output eDP-1 disable
    bindswitch --reload --locked lid:off output eDP-1 enable
  '';
}
